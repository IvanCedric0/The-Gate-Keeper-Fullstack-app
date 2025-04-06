<template>
  <div id="app">
    <nav v-if="isAuthenticated" class="navbar">
      <h1>The Gatekeeper Management System</h1>
      <button @click="handleLogout" class="logout-btn">Logout</button>
    </nav>
    <div v-if="!isAuthenticated">
      <LoginForm @login-success="handleLoginSuccess" />
    </div>
    <div v-else>
      <StudentForm @student-added="refreshStudents" />
      <StudentList 
        :students="students" 
        @student-updated="refreshStudents"
        @student-deleted="refreshStudents"
      />
    </div>
  </div>
</template>

<script>
import LoginForm from './components/Login.vue'
import StudentForm from './components/StudentForm.vue'
import StudentList from './components/StudentList.vue'

export default {
  name: 'App',
  components: {
    LoginForm,
    StudentForm,
    StudentList
  },
  data() {
    return {
      isAuthenticated: false,
      students: []
    }
  },
  methods: {
    async fetchStudents() {
      try {
        const token = localStorage.getItem('adminToken');
        if (!token) {
          throw new Error('Not authenticated');
        }

        console.log('Fetching students with token:', token.substring(0, 10) + '...');
        const response = await fetch('http://localhost:3000/api/students', {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        if (!response.ok) {
          const errorData = await response.json().catch(() => ({}));
          throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        console.log('Received students data:', data);
        this.students = data;
      } catch (error) {
        console.error('Error fetching students:', error);
        if (error.message.includes('Failed to fetch')) {
          alert('Unable to connect to the server. Please make sure the backend server is running.');
        } else {
          alert(error.message || 'Failed to fetch students');
        }
      }
    },
    handleLoginSuccess() {
      this.isAuthenticated = true;
      this.fetchStudents();
    },
    handleLogout() {
      localStorage.removeItem('adminToken');
      this.isAuthenticated = false;
      this.students = [];
    },
    refreshStudents() {
      this.fetchStudents();
    }
  },
  created() {
    // Check if user is already authenticated
    const token = localStorage.getItem('adminToken');
    if (token) {
      this.isAuthenticated = true;
      this.fetchStudents();
    }
  }
}
</script>

<style>
#app {
  font-family: Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  min-height: 100vh;
}

.navbar {
  background-color: #2c3e50;
  color: white;
  padding: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logout-btn {
  background-color: transparent;
  border: 1px solid white;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}

.logout-btn:hover {
  background-color: white;
  color: #2c3e50;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}
</style> 