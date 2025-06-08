<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>User Management - Hotel Management System</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="${pageContext.request.contextPath}/css/style.css"
      rel="stylesheet"
    />
    <style>
      .kpi-card {
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        border: none;
        border-radius: 12px;
      }
      .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
      }
      .table-actions .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
      }
      .status-badge {
        font-size: 0.75rem;
        padding: 0.35rem 0.65rem;
      }
      .page-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 12px;
        padding: 2rem;
        margin-bottom: 2rem;
      }
      .breadcrumb {
        background: rgba(255,255,255,0.1);
        border-radius: 8px;
        padding: 0.5rem 1rem;
      }
      .breadcrumb-item a {
        color: rgba(255,255,255,0.8);
        text-decoration: none;
      }
      .breadcrumb-item.active {
        color: white;
      }
    </style>
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <!-- Include Sidebar -->
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="users" />
      </jsp:include>
      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Include Top Navigation -->
        <jsp:include page="includes/header.jsp" />
        <div class="container-fluid py-4">
          <!-- Page Header -->
          <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h1 class="h2 mb-2">User Management</h1>
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fas fa-home me-1"></i>Home</a></li>
                    <li class="breadcrumb-item active">User Management</li>
                  </ol>
                </nav>
              </div>
              <div class="btn-group">
                <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addUserModal">
                  <i class="fas fa-plus me-2"></i>Add New User
                </button>
              </div>
            </div>
          </div>
          <!-- Statistics Cards -->
          <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Total Users</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">1,247</h2>
                  <p class="card-text text-primary">
                    <i class="fas fa-users me-1"></i> All registered users
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Customer</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">1,156</h2>
                  <p class="card-text text-success">
                    <i class="fas fa-user me-1"></i> Customer accounts
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Admin</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">12</h2>
                  <p class="card-text text-danger">
                    <i class="fas fa-user-shield me-1"></i> Administrator
                    accounts
                  </p>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card kpi-card shadow-sm">
                <div class="card-body">
                  <h6 class="card-subtitle mb-2 text-muted">Staff</h6>
                  <h2 class="card-title display-6 fw-bold mb-1">79</h2>
                  <p class="card-text text-info">
                    <i class="fas fa-user-tie me-1"></i> Staff accounts
                  </p>
                </div>
              </div>
            </div>
          </div>
          <!-- User Management Table -->
          <div class="card shadow-sm">
            <div class="card-header bg-white border-bottom py-3">
              <div class="row align-items-center">
                <div class="col">
                  <h5 class="mb-0">User List</h5>
                </div>
                <div class="col-auto">
                  <div class="input-group">
                    <input
                      type="text"
                      class="form-control"
                      placeholder="Search users..."
                      id="searchInput"
                    />
                    <button class="btn btn-outline-secondary" type="button">
                      <i class="fas fa-search"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-body p-0">
              <!-- Filter Section -->
              <div class="p-3 border-bottom bg-light">
                <div class="row g-3">
                  <div class="col-md-3">
                    <select class="form-select" id="roleFilter">
                      <option value="">All Roles</option>
                      <option value="admin">Admin</option>
                      <option value="manager">Manager</option>
                      <option value="staff">Staff</option>
                      <option value="customer">Customer</option>
                    </select>
                  </div>
                  <div class="col-md-3">
                    <select class="form-select" id="statusFilter">
                      <option value="">All Status</option>
                      <option value="active">Active</option>
                      <option value="inactive">Inactive</option>
                      <option value="suspended">Suspended</option>
                    </select>
                  </div>
                  <div class="col-md-3">
                    <input
                      type="date"
                      class="form-control"
                      id="dateFilter"
                      placeholder="Registration Date"
                    />
                  </div>
                  <div class="col-md-3">
                    <button
                      class="btn btn-outline-primary w-100"
                      onclick="applyFilters()"
                    >
                      <i class="fas fa-filter me-2"></i>Apply Filters
                    </button>
                  </div>
                </div>
              </div>
              <div class="table-responsive">
                <table
                  class="table table-striped table-hover align-middle mb-0"
                >
                  <thead class="table-light">
                    <tr>
                      <th>
                        <input
                          type="checkbox"
                          class="form-check-input"
                          id="selectAll"
                        />
                      </th>
                      <th>User ID</th>
                      <th>Avatar</th>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Role</th>
                      <th>Status</th>
                      <th>Registration Date</th>
                      <th>Last Login</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <input type="checkbox" class="form-check-input" />
                      </td>
                      <td><strong>#001</strong></td>
                      <td>
                        <img
                          src="https://via.placeholder.com/40x40"
                          class="rounded-circle"
                          alt="User Avatar"
                          width="40"
                          height="40"
                        />
                      </td>
                      <td>
                        <div>
                          <strong>John Smith</strong>
                          <br />
                          <small class="text-muted">@johnsmith</small>
                        </div>
                      </td>
                      <td>john.smith@email.com</td>
                      <td><span class="badge bg-danger">Admin</span></td>
                      <td><span class="badge bg-success">Active</span></td>
                      <td>2024-01-15</td>
                      <td>2025-05-25 10:30</td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                            onclick="viewUser(1)"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-warning"
                            title="Edit User"
                            onclick="editUser(1)"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-outline-danger"
                            title="Delete User"
                            onclick="deleteUser(1)"
                          >
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input type="checkbox" class="form-check-input" />
                      </td>
                      <td><strong>#002</strong></td>
                      <td>
                        <img
                          src="https://via.placeholder.com/40x40"
                          class="rounded-circle"
                          alt="User Avatar"
                          width="40"
                          height="40"
                        />
                      </td>
                      <td>
                        <div>
                          <strong>Maria Garcia</strong>
                          <br />
                          <small class="text-muted">@mariagarcia</small>
                        </div>
                      </td>
                      <td>maria.garcia@email.com</td>
                      <td><span class="badge bg-info">Manager</span></td>
                      <td><span class="badge bg-success">Active</span></td>
                      <td>2024-02-20</td>
                      <td>2025-05-24 16:45</td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                            onclick="viewUser(2)"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-warning"
                            title="Edit User"
                            onclick="editUser(2)"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-outline-danger"
                            title="Delete User"
                            onclick="deleteUser(2)"
                          >
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input type="checkbox" class="form-check-input" />
                      </td>
                      <td><strong>#003</strong></td>
                      <td>
                        <img
                          src="https://via.placeholder.com/40x40"
                          class="rounded-circle"
                          alt="User Avatar"
                          width="40"
                          height="40"
                        />
                      </td>
                      <td>
                        <div>
                          <strong>David Johnson</strong>
                          <br />
                          <small class="text-muted">@davidjohnson</small>
                        </div>
                      </td>
                      <td>david.johnson@email.com</td>
                      <td><span class="badge bg-secondary">Staff</span></td>
                      <td><span class="badge bg-warning">Inactive</span></td>
                      <td>2024-03-10</td>
                      <td>2025-05-20 09:15</td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                            onclick="viewUser(3)"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-warning"
                            title="Edit User"
                            onclick="editUser(3)"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-outline-danger"
                            title="Delete User"
                            onclick="deleteUser(3)"
                          >
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input type="checkbox" class="form-check-input" />
                      </td>
                      <td><strong>#004</strong></td>
                      <td>
                        <img
                          src="https://via.placeholder.com/40x40"
                          class="rounded-circle"
                          alt="User Avatar"
                          width="40"
                          height="40"
                        />
                      </td>
                      <td>
                        <div>
                          <strong>Sarah Wilson</strong>
                          <br />
                          <small class="text-muted">@sarahwilson</small>
                        </div>
                      </td>
                      <td>sarah.wilson@email.com</td>
                      <td><span class="badge bg-primary">Customer</span></td>
                      <td><span class="badge bg-success">Active</span></td>
                      <td>2024-04-05</td>
                      <td>2025-05-25 14:20</td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button
                            class="btn btn-outline-primary"
                            title="View Details"
                            onclick="viewUser(4)"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-outline-warning"
                            title="Edit User"
                            onclick="editUser(4)"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-outline-danger"
                            title="Delete User"
                            onclick="deleteUser(4)"
                          >
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!-- Pagination -->
              <div class="p-3 border-top">
                <div
                  class="d-flex justify-content-between align-items-center flex-wrap"
                >
                  <small class="text-muted mb-2 mb-md-0"
                    >Showing 1 to 4 of 1,247 users</small
                  >
                  <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                      <li class="page-item disabled">
                        <a class="page-link" href="#">Previous</a>
                      </li>
                      <li class="page-item active">
                        <a class="page-link" href="#">1</a>
                      </li>
                      <li class="page-item">
                        <a class="page-link" href="#">2</a>
                      </li>
                      <li class="page-item">
                        <a class="page-link" href="#">3</a>
                      </li>
                      <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                      </li>
                    </ul>
                  </nav>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Add User Modal -->
    <div
      class="modal fade"
      id="addUserModal"
      tabindex="-1"
      aria-labelledby="addUserModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form id="addUserForm">
              <div class="row g-3">
                <div class="col-md-6">
                  <label for="firstName" class="form-label">First Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="firstName"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="lastName" class="form-label">Last Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="lastName"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="username" class="form-label">Username</label>
                  <input
                    type="text"
                    class="form-control"
                    id="username"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="email" class="form-label">Email</label>
                  <input
                    type="email"
                    class="form-control"
                    id="email"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="password" class="form-label">Password</label>
                  <input
                    type="password"
                    class="form-control"
                    id="password"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="confirmPassword" class="form-label"
                    >Confirm Password</label
                  >
                  <input
                    type="password"
                    class="form-control"
                    id="confirmPassword"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="role" class="form-label">Role</label>
                  <select class="form-select" id="role" required>
                    <option value="">Select Role</option>
                    <option value="admin">Admin</option>
                    <option value="manager">Manager</option>
                    <option value="staff">Staff</option>
                    <option value="customer">Customer</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label for="status" class="form-label">Status</label>
                  <select class="form-select" id="status" required>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                  </select>
                </div>
                <div class="col-12">
                  <label for="avatar" class="form-label">Avatar</label>
                  <input type="file" class="form-control" id="avatar" />
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <button type="button" class="btn btn-primary" onclick="saveUser()">
              <i class="fas fa-save me-2"></i>Save User
            </button>
          </div>
        </div>
      </div>
    </div>
    <!-- Edit User Modal -->
    <div
      class="modal fade"
      id="editUserModal"
      tabindex="-1"
      aria-labelledby="editUserModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form id="editUserForm">
              <input type="hidden" id="editUserId" />
              <div class="row g-3">
                <div class="col-md-6">
                  <label for="editFirstName" class="form-label"
                    >First Name</label
                  >
                  <input
                    type="text"
                    class="form-control"
                    id="editFirstName"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="editLastName" class="form-label">Last Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="editLastName"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="editUsername" class="form-label">Username</label>
                  <input
                    type="text"
                    class="form-control"
                    id="editUsername"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="editEmail" class="form-label">Email</label>
                  <input
                    type="email"
                    class="form-control"
                    id="editEmail"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="editRole" class="form-label">Role</label>
                  <select class="form-select" id="editRole" required>
                    <option value="">Select Role</option>
                    <option value="admin">Admin</option>
                    <option value="manager">Manager</option>
                    <option value="staff">Staff</option>
                    <option value="customer">Customer</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label for="editStatus" class="form-label">Status</label>
                  <select class="form-select" id="editStatus" required>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                    <option value="suspended">Suspended</option>
                  </select>
                </div>
                <div class="col-12">
                  <label for="editAvatar" class="form-label">Avatar</label>
                  <input type="file" class="form-control" id="editAvatar" />
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <button
              type="button"
              class="btn btn-primary"
              onclick="updateUser()"
            >
              <i class="fas fa-save me-2"></i>Update User
            </button>
          </div>
        </div>
      </div>
    </div>
    <!-- View User Modal -->
    <div
      class="modal fade"
      id="viewUserModal"
      tabindex="-1"
      aria-labelledby="viewUserModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="viewUserModalLabel">User Details</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div id="userDetails">
              <!-- User details will be loaded here -->
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Sidebar toggle functionality
      document
        .getElementById("menu-toggle")
        ?.addEventListener("click", function () {
          document
            .getElementById("sidebar-wrapper")
            ?.classList.toggle("toggled");
        });
      // Select all functionality
      document
        .getElementById("selectAll")
        .addEventListener("change", function () {
          const checkboxes = document.querySelectorAll(
            'tbody input[type="checkbox"]'
          );
          checkboxes.forEach((checkbox) => {
            checkbox.checked = this.checked;
          });
        });
      // Search functionality
      document
        .getElementById("searchInput")
        .addEventListener("input", function () {
          const searchTerm = this.value.toLowerCase();
          const rows = document.querySelectorAll("tbody tr");
          rows.forEach((row) => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? "" : "none";
          });
        });
      // Functions
      function applyFilters() {
        const role = document.getElementById("roleFilter").value;
        const status = document.getElementById("statusFilter").value;
        const date = document.getElementById("dateFilter").value;
        alert(`Applying filters: Role=${role}, Status=${status}, Date=${date}`);
        // Implementation for actual filtering would go here
      }
      function viewUser(userId) {
        // Sample user data - in real implementation, this would come from server
        const userData = {
          1: {
            id: 1,
            name: "John Smith",
            username: "johnsmith",
            email: "john.smith@email.com",
            role: "Admin",
            status: "Active",
            registrationDate: "2024-01-15",
            lastLogin: "2025-05-25 10:30",
            avatar: "https://via.placeholder.com/100x100",
          },
        };
        const user = userData[userId];
        if (user) {
          document.getElementById("userDetails").innerHTML = `
            <div class="row">
              <div class="col-md-4 text-center">
                <img src="${
                  user.avatar
                }" class="rounded-circle mb-3" alt="User Avatar" width="100" height="100">
                <h5>${user.name}</h5>
                <p class="text-muted">@${user.username}</p>
              </div>
              <div class="col-md-8">
                <table class="table table-borderless">
                  <tr>
                    <td><strong>User ID:</strong></td>
                    <td>#${user.id.toString().padStart(3, "0")}</td>
                  </tr>
                  <tr>
                    <td><strong>Email:</strong></td>
                    <td>${user.email}</td>
                  </tr>
                  <tr>
                    <td><strong>Role:</strong></td>
                    <td><span class="badge bg-danger">${user.role}</span></td>
                  </tr>
                  <tr>
                    <td><strong>Status:</strong></td>
                    <td><span class="badge bg-success">${
                      user.status
                    }</span></td>
                  </tr>
                  <tr>
                    <td><strong>Registration Date:</strong></td>
                    <td>${user.registrationDate}</td>
                  </tr>
                  <tr>
                    <td><strong>Last Login:</strong></td>
                    <td>${user.lastLogin}</td>
                  </tr>
                </table>
              </div>
            </div>
          `;
          const modal = new bootstrap.Modal(
            document.getElementById("viewUserModal")
          );
          modal.show();
        }
      }
      function editUser(userId) {
        // Sample user data - in real implementation, this would come from server
        const userData = {
          1: {
            id: 1,
            firstName: "John",
            lastName: "Smith",
            username: "johnsmith",
            email: "john.smith@email.com",
            role: "admin",
            status: "active",
          },
        };
        const user = userData[userId];
        if (user) {
          document.getElementById("editUserId").value = user.id;
          document.getElementById("editFirstName").value = user.firstName;
          document.getElementById("editLastName").value = user.lastName;
          document.getElementById("editUsername").value = user.username;
          document.getElementById("editEmail").value = user.email;
          document.getElementById("editRole").value = user.role;
          document.getElementById("editStatus").value = user.status;
          const modal = new bootstrap.Modal(
            document.getElementById("editUserModal")
          );
          modal.show();
        }
      }
      function deleteUser(userId) {
        if (
          confirm(
            "Are you sure you want to delete this user? This action cannot be undone."
          )
        ) {
          alert(`Deleting user with ID: ${userId}`);
          // Implementation for actual deletion would go here
        }
      }
      function saveUser() {
        const form = document.getElementById("addUserForm");
        if (form.checkValidity()) {
          alert("User saved successfully!");
          // Implementation for actual saving would go here
          const modal = bootstrap.Modal.getInstance(
            document.getElementById("addUserModal")
          );
          modal.hide();
          form.reset();
        } else {
          form.reportValidity();
        }
      }
      function updateUser() {
        const form = document.getElementById("editUserForm");
        if (form.checkValidity()) {
          alert("User updated successfully!");
          // Implementation for actual updating would go here
          const modal = bootstrap.Modal.getInstance(
            document.getElementById("editUserModal")
          );
          modal.hide();
        } else {
          form.reportValidity();
        }
      }
    </script>
  </body>
</html>