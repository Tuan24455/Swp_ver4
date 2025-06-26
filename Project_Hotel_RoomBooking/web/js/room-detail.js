// Room Detail Page JavaScript
document.addEventListener("DOMContentLoaded", () => {
  // Initialize page
  initializePage()

  // Set up event listeners
  setupEventListeners()

  // Initialize date inputs
  initializeDateInputs()

  // Add smooth scrolling
  addSmoothScrolling()

  // Initialize animations
  initializeAnimations()

  // Initialize lazy loading
  lazyLoadImages()
})

function initializePage() {
  // Add loading animation to images
  const images = document.querySelectorAll(".carousel-item img")
  images.forEach((img) => {
    img.addEventListener("load", function () {
      this.style.opacity = "1"
    })
  })

  // Add entrance animations
  const elements = document.querySelectorAll(".room-detail-card, .room-info-section")
  elements.forEach((element, index) => {
    element.style.opacity = "0"
    element.style.transform = "translateY(30px)"

    setTimeout(() => {
      element.style.transition = "all 0.6s ease"
      element.style.opacity = "1"
      element.style.transform = "translateY(0)"
    }, index * 200)
  })
}

function setupEventListeners() {
  // Booking form submission
  const bookingForm = document.querySelector(".booking-section form")
  if (bookingForm) {
    bookingForm.addEventListener("submit", handleBookingSubmission)
  }

  // Detail items hover effects
  const detailItems = document.querySelectorAll(".detail-item")
  detailItems.forEach((item) => {
    item.addEventListener("mouseenter", function () {
      this.style.borderLeftColor = getRandomColor()
    })

    item.addEventListener("mouseleave", function () {
      this.style.borderLeftColor = "#3498db"
    })
  })

  // Amenity items click effects
  const amenityItems = document.querySelectorAll(".amenity-item")
  amenityItems.forEach((item) => {
    item.addEventListener("click", function () {
      this.style.animation = "none"
      setTimeout(() => {
        this.style.animation = "pulse 0.6s ease-in-out"
      }, 10)
    })
  })

  // Carousel auto-play control
  const carousel = document.querySelector("#roomImages")
  const bootstrap = window.bootstrap // Declare bootstrap variable
  if (carousel) {
    const isPlaying = true

    carousel.addEventListener("mouseenter", function () {
      if (isPlaying) {
        bootstrap.Carousel.getInstance(this).pause()
      }
    })

    carousel.addEventListener("mouseleave", function () {
      if (isPlaying) {
        bootstrap.Carousel.getInstance(this).cycle()
      }
    })
  }
}

function initializeDateInputs() {
  const today = new Date().toISOString().split("T")[0]
  const checkInInput = document.getElementById("checkIn")
  const checkOutInput = document.getElementById("checkOut")

  if (checkInInput && checkOutInput) {
    // Set minimum dates
    checkInInput.min = today
    checkOutInput.min = today

    // Add date validation
    checkInInput.addEventListener("change", function () {
      const checkInDate = new Date(this.value)
      const nextDay = new Date(checkInDate)
      nextDay.setDate(nextDay.getDate() + 1)

      checkOutInput.min = nextDay.toISOString().split("T")[0]

      // Clear checkout if it's before new checkin
      if (checkOutInput.value && new Date(checkOutInput.value) <= checkInDate) {
        checkOutInput.value = ""
        showMessage("Vui lòng chọn lại ngày trả phòng", "warning")
      }

      // Add visual feedback
      this.style.borderColor = "#27ae60"
      setTimeout(() => {
        this.style.borderColor = "#e9ecef"
      }, 1000)
    })

    checkOutInput.addEventListener("change", function () {
      // Add visual feedback
      this.style.borderColor = "#27ae60"
      setTimeout(() => {
        this.style.borderColor = "#e9ecef"
      }, 1000)
    })

    // Add date picker enhancements
    ;[checkInInput, checkOutInput].forEach((input) => {
      input.addEventListener("focus", function () {
        this.style.transform = "scale(1.02)"
      })

      input.addEventListener("blur", function () {
        this.style.transform = "scale(1)"
      })
    })
  }
}

function handleBookingSubmission(event) {
  event.preventDefault()

  const form = event.target
  const submitButton = form.querySelector(".btn-book")
  const checkIn = form.querySelector("#checkIn").value
  const checkOut = form.querySelector("#checkOut").value

  // Validation
  if (!checkIn || !checkOut) {
    showMessage("Vui lòng chọn ngày nhận và trả phòng", "error")
    return
  }

  if (new Date(checkOut) <= new Date(checkIn)) {
    showMessage("Ngày trả phòng phải sau ngày nhận phòng", "error")
    return
  }

  // Show loading state
  const originalText = submitButton.innerHTML
  submitButton.innerHTML = '<span class="loading"></span> Đang xử lý...'
  submitButton.disabled = true

  // Calculate stay duration and price
  const stayDuration = calculateStayDuration(checkIn, checkOut)
  const totalPrice = calculateTotalPrice(stayDuration)

  // Show booking confirmation
  setTimeout(() => {
    showBookingConfirmation(checkIn, checkOut, stayDuration, totalPrice)

    // Reset button
    submitButton.innerHTML = originalText
    submitButton.disabled = false

    // Submit form after confirmation
    setTimeout(() => {
      form.submit()
    }, 2000)
  }, 1500)
}

function calculateStayDuration(checkIn, checkOut) {
  const startDate = new Date(checkIn)
  const endDate = new Date(checkOut)
  const timeDiff = endDate.getTime() - startDate.getTime()
  return Math.ceil(timeDiff / (1000 * 3600 * 24))
}

function calculateTotalPrice(duration) {
  // Get room price from the page (you might need to adjust this selector)
  const priceElement = document.querySelector(".detail-item span")
  let roomPrice = 1500000 // Default price

  if (priceElement) {
    const priceText = priceElement.textContent
    const priceMatch = priceText.match(/(\d+)/)
    if (priceMatch) {
      roomPrice = Number.parseInt(priceMatch[1])
    }
  }

  return roomPrice * duration
}

function showBookingConfirmation(checkIn, checkOut, duration, totalPrice) {
  const confirmationHTML = `
        <div class="booking-confirmation">
            <h5>Xác nhận đặt phòng</h5>
            <p><strong>Ngày nhận phòng:</strong> ${formatDate(checkIn)}</p>
            <p><strong>Ngày trả phòng:</strong> ${formatDate(checkOut)}</p>
            <p><strong>Số đêm:</strong> ${duration} đêm</p>
            <p><strong>Tổng tiền:</strong> ${formatPrice(totalPrice)}đ</p>
        </div>
    `

  showMessage(confirmationHTML, "success")
}

function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString("vi-VN", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  })
}

function formatPrice(price) {
  return new Intl.NumberFormat("vi-VN").format(price)
}

function showMessage(message, type = "info") {
  // Remove existing messages
  const existingMessages = document.querySelectorAll(".message")
  existingMessages.forEach((msg) => msg.remove())

  // Create message element
  const messageDiv = document.createElement("div")
  messageDiv.className = `message ${type}-message`
  messageDiv.innerHTML = message

  // Insert message
  const bookingSection = document.querySelector(".booking-section")
  if (bookingSection) {
    bookingSection.insertBefore(messageDiv, bookingSection.firstChild)

    // Auto remove after 5 seconds
    setTimeout(() => {
      if (messageDiv.parentNode) {
        messageDiv.remove()
      }
    }, 5000)
  }
}

function addSmoothScrolling() {
  // Add smooth scrolling to anchor links
  const links = document.querySelectorAll('a[href^="#"]')
  links.forEach((link) => {
    link.addEventListener("click", function (e) {
      e.preventDefault()
      const target = document.querySelector(this.getAttribute("href"))
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
          block: "start",
        })
      }
    })
  })
}

function initializeAnimations() {
  // Intersection Observer for scroll animations
  const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px",
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("animate-in")
      }
    })
  }, observerOptions)

  // Observe elements for animation
  const animateElements = document.querySelectorAll(".detail-item, .amenity-item")
  animateElements.forEach((el) => {
    observer.observe(el)
  })

  // Add CSS for scroll animations
  const style = document.createElement("style")
  style.textContent = `
        .animate-in {
            animation: slideInUp 0.6s ease-out forwards;
        }
        
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    `
  document.head.appendChild(style)
}

function getRandomColor() {
  const colors = ["#3498db", "#e74c3c", "#f39c12", "#27ae60", "#9b59b6", "#1abc9c"]
  return colors[Math.floor(Math.random() * colors.length)]
}

// Utility functions
function debounce(func, wait) {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

// Add resize handler for responsive adjustments
window.addEventListener(
  "resize",
  debounce(() => {
    // Adjust carousel height on mobile
    const carousel = document.querySelector(".carousel-container")
    if (carousel && window.innerWidth < 768) {
      carousel.style.height = "250px"
    } else if (carousel) {
      carousel.style.height = "400px"
    }
  }, 250),
)

// Add keyboard navigation for carousel
document.addEventListener("keydown", (e) => {
  const carousel = document.querySelector("#roomImages")
  const bootstrap = window.bootstrap // Declare bootstrap variable
  if (carousel && document.activeElement === carousel) {
    if (e.key === "ArrowLeft") {
      bootstrap.Carousel.getInstance(carousel).prev()
    } else if (e.key === "ArrowRight") {
      bootstrap.Carousel.getInstance(carousel).next()
    }
  }
})

// Performance optimization: Lazy load images
function lazyLoadImages() {
  const images = document.querySelectorAll("img[data-src]")
  const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const img = entry.target
        img.src = img.dataset.src
        img.classList.remove("lazy")
        imageObserver.unobserve(img)
      }
    })
  })

  images.forEach((img) => imageObserver.observe(img))
}
