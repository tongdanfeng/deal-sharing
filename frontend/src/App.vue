<template>
  <div id="app">
    <nav class="navbar">
      <div class="container">
        <div class="nav-content">
          <router-link to="/" class="logo">🔥 好价分享</router-link>
          <div class="nav-links">
            <router-link to="/">首页</router-link>
          </div>
        </div>
      </div>
    </nav>
    <router-view />
  </div>
</template>

<script setup>
</script>

<style scoped>
.navbar {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
}

.logo {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b6b;
  text-decoration: none;
}

.nav-links {
  display: flex;
  gap: 20px;
}

.nav-links a {
  color: #333;
  text-decoration: none;
  font-size: 16px;
  transition: color 0.3s;
}

.nav-links a:hover,
.nav-links a.router-link-active {
  color: #ff6b6b;
}
</style>
