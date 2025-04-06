<template>
  <div class="student-list">
    <h2>Student List</h2>
    <div class="students-grid">
      <div v-for="student in students" :key="student.id" class="student-card">
        <img :src="student.photo" alt="Student photo" class="student-photo">
        <div class="student-info">
          <h3>{{ student.fullname }}</h3>
          <p><strong>ID:</strong> {{ student.id }}</p>
          <p><strong>Major:</strong> {{ student.major }}</p>
          <div class="qr-section">
            <img :src="student.qr_code" alt="QR Code" class="qr-code">
            <a :href="student.qr_code" :download="`qr-${student.id}.png`" class="download-btn">
              Download QR
            </a>
          </div>
          <div class="action-buttons">
            <button @click="editStudent(student)" class="edit-btn">Edit</button>
            <button @click="deleteStudent(student.id)" class="delete-btn">Delete</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Student Modal -->
    <div v-if="showEditModal" class="modal">
      <div class="modal-content">
        <h3>Edit Student</h3>
        <form @submit.prevent="saveEdit">
          <div class="form-group">
            <label>Full Name:</label>
            <input v-model="editingStudent.fullname" required>
          </div>
          <div class="form-group">
            <label>Major:</label>
            <input v-model="editingStudent.major" required>
          </div>
          <div class="form-group">
            <label>Photo:</label>
            <input type="file" @change="handlePhotoChange" accept="image/*">
          </div>
          <div class="modal-buttons">
            <button type="submit" class="save-btn">Save</button>
            <button type="button" @click="closeEditModal" class="cancel-btn">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StudentList',
  props: {
    students: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      showEditModal: false,
      editingStudent: {
        id: '',
        fullname: '',
        major: '',
        photo: null
      }
    }
  },
  methods: {
    editStudent(student) {
      this.editingStudent = { ...student };
      this.showEditModal = true;
    },
    closeEditModal() {
      this.showEditModal = false;
      this.editingStudent = {
        id: '',
        fullname: '',
        major: '',
        photo: null
      };
    },
    handlePhotoChange(event) {
      this.editingStudent.photo = event.target.files[0];
    },
    async saveEdit() {
      try {
        const formData = new FormData();
        formData.append('fullname', this.editingStudent.fullname);
        formData.append('major', this.editingStudent.major);
        if (this.editingStudent.photo) {
          formData.append('photo', this.editingStudent.photo);
        }

        const token = localStorage.getItem('adminToken');
        const response = await fetch(`http://localhost:3000/api/students/${this.editingStudent.id}`, {
          method: 'PUT',
          headers: {
            'Authorization': `Bearer ${token}`
          },
          body: formData
        });

        if (!response.ok) {
          throw new Error('Failed to update student');
        }

        this.$emit('student-updated');
        this.closeEditModal();
      } catch (error) {
        console.error('Error updating student:', error);
        alert('Failed to update student. Please try again.');
      }
    },
    async deleteStudent(studentId) {
      if (!confirm('Are you sure you want to delete this student?')) {
        return;
      }

      try {
        const token = localStorage.getItem('adminToken');
        const response = await fetch(`http://localhost:3000/api/students/${studentId}`, {
          method: 'DELETE',
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });

        if (!response.ok) {
          throw new Error('Failed to delete student');
        }

        this.$emit('student-deleted');
      } catch (error) {
        console.error('Error deleting student:', error);
        alert('Failed to delete student. Please try again.');
      }
    }
  }
}
</script>

<style scoped>
.student-list {
  padding: 20px;
}

.students-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.student-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  background: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.student-photo {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 4px;
  margin-bottom: 10px;
}

.student-info {
  text-align: left;
}

.student-info h3 {
  margin: 0 0 10px 0;
  color: #333;
}

.student-info p {
  margin: 5px 0;
  color: #666;
}

.qr-section {
  margin-top: 15px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.qr-code {
  width: 150px;
  height: 150px;
  margin-bottom: 10px;
}

.download-btn {
  display: inline-block;
  padding: 8px 16px;
  background-color: #4CAF50;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.download-btn:hover {
  background-color: #45a049;
}

.action-buttons {
  margin-top: 15px;
  display: flex;
  gap: 10px;
  justify-content: center;
}

.edit-btn, .delete-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.edit-btn {
  background-color: #2c3e50;
  color: white;
}

.delete-btn {
  background-color: #f44336;
  color: white;
}

.edit-btn:hover {
  background-color: #1a252f;
}

.delete-btn:hover {
  background-color: #D32F2F;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-group input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.modal-buttons {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

.save-btn, .cancel-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.save-btn {
  background-color: #4CAF50;
  color: white;
}

.cancel-btn {
  background-color: #f44336;
  color: white;
}

.save-btn:hover {
  background-color: #45a049;
}

.cancel-btn:hover {
  background-color: #D32F2F;
}
</style> 