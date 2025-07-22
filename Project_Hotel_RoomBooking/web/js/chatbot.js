/**
 * Chatbot JavaScript for Hotel Management System
 * Integrates with Gemini AI through ChatbotServlet
 */

class HotelChatbot {
    constructor(chatboxId = 'chatbox-frame', inputId = 'chat-input', messagesId = 'chat-messages') {
        this.chatbox = document.getElementById(chatboxId);
        this.input = document.getElementById(inputId);
        this.messages = document.getElementById(messagesId);
        this.apiEndpoint = '/Project_Hotel_RoomBooking/chatbot';
        
        this.init();
    }
    
    init() {
        // Add event listener for Enter key
        if (this.input) {
            this.input.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    this.sendMessage();
                }
            });
        }
    }
    
    sendMessage() {
        const messageText = this.input.value.trim();
        if (!messageText) {
            console.log('No message to send');
            return;
        }
        
        console.log('Sending user message:', messageText);
        
        const time = this.getCurrentTime();
        
        // Add user message to chat
        this.addUserMessage(messageText, time);
        this.input.value = '';
        this.scrollToBottom();
        
        // Show typing indicator
        this.showTypingIndicator();
        
        // Send message to server
        this.callChatbotAPI(messageText)
            .then(data => {
                this.removeTypingIndicator();
                
                if (data.success) {
                    this.addBotMessage(data.message, time);
                } else {
                    this.addBotMessage(data.message || 'Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau.', time);
                }
                this.scrollToBottom();
            })
            .catch(error => {
                console.error('Chatbot API Error:', error);
                this.removeTypingIndicator();
                this.addBotMessage('Xin lỗi, tôi đang gặp sự cố kết nối. Vui lòng thử lại sau.', time);
                this.scrollToBottom();
            });
    }
    
    async callChatbotAPI(message) {
        const response = await fetch(this.apiEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({
                message: message
            })
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    }
    
    addUserMessage(messageText, time) {
        const userMessage = this.createMessageElement('user', messageText, time, 'fas fa-user');
        this.messages.appendChild(userMessage);
    }
    
    addBotMessage(messageText, time) {
        const botMessage = this.createMessageElement('bot', messageText, time, 'fas fa-robot');
        this.messages.appendChild(botMessage);
    }
    
    createMessageElement(type, messageText, time, iconClass) {
        const message = document.createElement('div');
        message.className = `message ${type}`;
        
        const contentDiv = document.createElement('div');
        const bubble = document.createElement('div');
        bubble.className = 'bubble';
        bubble.textContent = messageText;
        
        const timeDiv = document.createElement('div');
        timeDiv.className = 'time';
        timeDiv.textContent = time;
        
        contentDiv.appendChild(bubble);
        contentDiv.appendChild(timeDiv);
        
        const avatarDiv = document.createElement('div');
        avatarDiv.className = 'avatar';
        const icon = document.createElement('i');
        icon.className = iconClass;
        avatarDiv.appendChild(icon);
        
        if (type === 'user') {
            message.appendChild(contentDiv);
            message.appendChild(avatarDiv);
        } else {
            message.appendChild(avatarDiv);
            message.appendChild(contentDiv);
        }
        
        return message;
    }
    
    showTypingIndicator() {
        const typingMessage = document.createElement('div');
        typingMessage.className = 'message bot typing-indicator';
        typingMessage.id = 'typing-indicator';
        
        const botAvatarDiv = document.createElement('div');
        botAvatarDiv.className = 'avatar';
        const botIcon = document.createElement('i');
        botIcon.className = 'fas fa-robot';
        botAvatarDiv.appendChild(botIcon);
        
        const botContentDiv = document.createElement('div');
        const botBubble = document.createElement('div');
        botBubble.className = 'bubble';
        botBubble.innerHTML = '<span class="typing-dots">●●●</span>';
        botBubble.style.backgroundColor = '#f0f0f0';
        
        botContentDiv.appendChild(botBubble);
        
        typingMessage.appendChild(botAvatarDiv);
        typingMessage.appendChild(botContentDiv);
        this.messages.appendChild(typingMessage);
        this.scrollToBottom();
    }
    
    removeTypingIndicator() {
        const typingIndicator = document.getElementById('typing-indicator');
        if (typingIndicator) {
            typingIndicator.remove();
        }
    }
    
    scrollToBottom() {
        this.messages.scrollTop = this.messages.scrollHeight;
    }
    
    getCurrentTime() {
        const now = new Date();
        return now.toLocaleTimeString('vi-VN', { 
            hour: '2-digit', 
            minute: '2-digit',
            hour12: false 
        });
    }
    
    // Method to toggle chatbox visibility
    toggleChatbox() {
        if (this.chatbox.style.display === 'none' || this.chatbox.style.display === '') {
            this.chatbox.style.display = 'block';
            this.chatbox.classList.add('animate__animated', 'animate__fadeInUp');
        } else {
            this.chatbox.style.display = 'none';
            this.chatbox.classList.remove('animate__animated', 'animate__fadeInUp');
        }
    }
}

// Global functions for backward compatibility
let hotelChatbot;

function initializeChatbot() {
    if (typeof HotelChatbot !== 'undefined') {
        hotelChatbot = new HotelChatbot();
    }
}

function sendMessage() {
    if (hotelChatbot) {
        hotelChatbot.sendMessage();
    }
}

function toggleChatbox() {
    if (hotelChatbot) {
        hotelChatbot.toggleChatbox();
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeChatbot);
