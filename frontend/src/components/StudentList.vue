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
        </div>
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
</style> 