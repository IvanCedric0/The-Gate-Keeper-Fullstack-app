<template>
  <div class="student-form">
    <h2>Add New Student</h2>
    <form @submit.prevent="submitForm">
      <div class="form-group">
        <label for="id">Student ID:</label>
        <input type="text" id="id" v-model="form.id" required>
      </div>
      
      <div class="form-group">
        <label for="fullname">Full Name:</label>
        <input type="text" id="fullname" v-model="form.fullname" required>
      </div>
      
      <div class="form-group">
        <label for="major">Major:</label>
        <input type="text" id="major" v-model="form.major" required>
      </div>
      
      <div class="form-group">
        <label for="photo">Photo:</label>
        <input 
          type="file" 
          id="photo" 
          @change="handleFileUpload" 
          accept="image/*"
          required
        >
        <img v-if="photoPreview" :src="photoPreview" class="photo-preview" alt="Preview">
      </div>
      
      <button type="submit" class="submit-btn">Add Student</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'StudentForm',
  data() {
    return {
      form: {
        id: '',
        fullname: '',
        major: '',
        photo: null
      },
      photoPreview: null
    }
  },
  methods: {
    handleFileUpload(event) {
      const file = event.target.files[0];
      if (file) {
        this.form.photo = file;
        this.photoPreview = URL.createObjectURL(file);
      }
    },
    async submitForm() {
      const formData = new FormData();
      formData.append('id', this.form.id);
      formData.append('fullname', this.form.fullname);
      formData.append('major', this.form.major);
      if (this.form.photo) {
        formData.append('photo', this.form.photo);
      }

      try {
        const token = localStorage.getItem('adminToken');
        if (!token) {
          throw new Error('Not authenticated');
        }

        const response = await fetch('http://localhost:3000/api/students', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`
          },
          body: formData
        });
        
        if (response.ok) {
          this.$emit('student-added');
          this.resetForm();
        } else {
          const errorData = await response.json();
          throw new Error(errorData.error || 'Failed to add student');
        }
      } catch (error) {
        console.error('Error adding student:', error);
        alert(error.message || 'Failed to add student. Please try again.');
      }
    },
    resetForm() {
      this.form = {
        id: '',
        fullname: '',
        major: '',
        photo: null
      };
      this.photoPreview = null;
    }
  }
}
</script>

<style scoped>
.student-form {
  background-color: #f8f9fa;
  padding: 2rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: bold;
}

input[type="text"] {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

input[type="file"] {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: white;
}

.photo-preview {
  max-width: 200px;
  margin-top: 1rem;
  border-radius: 4px;
}

.submit-btn {
  background-color: #2c3e50;
  color: white;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.submit-btn:hover {
  background-color: #34495e;
}
</style>