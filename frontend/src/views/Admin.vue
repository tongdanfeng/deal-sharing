<template>
  <div class="admin">
    <!-- 密码验证页面 -->
    <div v-if="!isAuthenticated" class="login-container">
      <div class="login-box">
        <h2>🔒 后台管理</h2>
        <p>请输入访问密码</p>
        <form @submit.prevent="handleLogin">
          <div class="form-group">
            <input 
              v-model="password" 
              type="password" 
              placeholder="请输入密码" 
              required
              autofocus
            />
          </div>
          <button type="submit" class="btn btn-primary">登录</button>
          <p v-if="loginError" class="error-msg">{{ loginError }}</p>
        </form>
      </div>
    </div>

    <!-- 后台管理内容 -->
    <div v-else class="container">
      <div class="admin-header">
        <h1>后台管理</h1>
        <div class="header-actions">
          <button class="btn btn-secondary" @click="handleLogout">退出登录</button>
          <button class="btn btn-primary" @click="showCreateModal = true">
            + 新增优惠
          </button>
        </div>
      </div>

      <!-- 优惠列表表格 -->
      <div class="table-container">
        <table class="deals-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>标题</th>
              <th>分类</th>
              <th>原价</th>
              <th>优惠价</th>
              <th>商家</th>
              <th>发布时间</th>
              <th>状态</th>
              <th>推荐</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="deal in deals" :key="deal.id">
              <td>{{ deal.id }}</td>
              <td class="title-cell">{{ deal.title }}</td>
              <td>{{ deal.category || '-' }}</td>
              <td>{{ deal.original_price ? '¥' + deal.original_price.toFixed(2) : '-' }}</td>
              <td class="price-cell">
                {{ deal.deal_price ? '¥' + deal.deal_price.toFixed(2) : '-' }}
              </td>
              <td>{{ deal.merchant || '-' }}</td>
              <td class="time-cell">{{ formatTime(deal.created_at) }}</td>
              <td>
                <span :class="['status', deal.is_active ? 'active' : 'inactive']">
                  {{ deal.is_active ? '有效' : '无效' }}
                </span>
              </td>
              <td>
                <span :class="['status', deal.is_featured ? 'featured' : '']">
                  {{ deal.is_featured ? '是' : '否' }}
                </span>
              </td>
              <td class="actions">
                <button class="btn btn-small" @click="editDeal(deal)">编辑</button>
                <button class="btn btn-danger btn-small" @click="deleteDeal(deal.id)">
                  删除
                </button>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-if="deals.length === 0" class="empty-state">
          <p>暂无数据</p>
        </div>
      </div>
    </div>

    <!-- 创建/编辑弹窗 -->
    <div v-if="showCreateModal || showEditModal" class="modal-overlay" @click="closeModal">
      <div class="modal" @click.stop>
        <div class="modal-header">
          <h2>{{ editingDeal ? '编辑优惠' : '新增优惠' }}</h2>
          <button class="close-btn" @click="closeModal">×</button>
        </div>
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label>标题 *</label>
            <input v-model="formData.title" type="text" required placeholder="请输入优惠标题" />
          </div>

          <div class="form-group">
            <label>描述</label>
            <textarea v-model="formData.description" rows="3" placeholder="优惠描述"></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>原价</label>
              <input v-model.number="formData.original_price" type="number" step="0.01" placeholder="0.00" />
            </div>
            <div class="form-group">
              <label>优惠价</label>
              <input v-model.number="formData.deal_price" type="number" step="0.01" placeholder="0.00" />
            </div>
            <div class="form-group">
              <label>折扣</label>
              <input v-model.number="formData.discount" type="number" step="0.1" placeholder="如: 5" />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>分类</label>
              <input v-model="formData.category" type="text" placeholder="如: 数码、食品" />
            </div>
            <div class="form-group">
              <label>商家</label>
              <input v-model="formData.merchant" type="text" placeholder="商家名称" />
            </div>
          </div>

          <div class="form-group">
            <label>购买链接</label>
            <input v-model="formData.link" type="url" placeholder="https://..." />
          </div>

          <div class="form-group">
            <label>图片URL</label>
            <input v-model="formData.image_url" type="url" placeholder="https://..." />
          </div>

          <div class="form-group">
            <label>优惠码</label>
            <input v-model="formData.coupon_code" type="text" placeholder="可选" />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>
                <input v-model="formData.is_active" type="checkbox" />
                有效
              </label>
            </div>
            <div class="form-group">
              <label>
                <input v-model="formData.is_featured" type="checkbox" />
                推荐
              </label>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn" @click="closeModal">取消</button>
            <button type="submit" class="btn btn-primary">
              {{ editingDeal ? '保存' : '创建' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { adminGetDeals, adminCreateDeal, adminUpdateDeal, adminDeleteDeal } from '../api'

// 密码验证
const isAuthenticated = ref(false)
const password = ref('')
const loginError = ref('')

// 设置你的密码（修改这里）
const ADMIN_PASSWORD = 'admin123'

const handleLogin = () => {
  if (password.value === ADMIN_PASSWORD) {
    isAuthenticated.value = true
    loginError.value = ''
    // 保存到 sessionStorage，关闭浏览器后失效
    sessionStorage.setItem('admin_auth', 'true')
  } else {
    loginError.value = '密码错误，请重试'
    password.value = ''
  }
}

const handleLogout = () => {
  isAuthenticated.value = false
  sessionStorage.removeItem('admin_auth')
  password.value = ''
}

// 检查是否已登录
onMounted(() => {
  if (sessionStorage.getItem('admin_auth') === 'true') {
    isAuthenticated.value = true
  }
  loadDeals()
})

const deals = ref([])
const showCreateModal = ref(false)
const showEditModal = ref(false)
const editingDeal = ref(null)

const formData = ref({
  title: '',
  description: '',
  original_price: null,
  deal_price: null,
  discount: null,
  category: '',
  merchant: '',
  link: '',
  image_url: '',
  coupon_code: '',
  is_active: true,
  is_featured: false
})

const loadDeals = async () => {
  try {
    const response = await adminGetDeals()
    deals.value = response.data
  } catch (error) {
    console.error('加载数据失败:', error)
    alert('加载数据失败')
  }
}

const formatTime = (timeStr) => {
  if (!timeStr) return '-'
  const date = new Date(timeStr)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}`
}

const editDeal = (deal) => {
  editingDeal.value = deal
  formData.value = { ...deal }
  showEditModal.value = true
}

const deleteDeal = async (id) => {
  if (!confirm('确定要删除这个优惠吗？')) return
  
  try {
    await adminDeleteDeal(id)
    alert('删除成功')
    loadDeals()
  } catch (error) {
    console.error('删除失败:', error)
    alert('删除失败')
  }
}

const handleSubmit = async () => {
  try {
    if (editingDeal.value) {
      await adminUpdateDeal(editingDeal.value.id, formData.value)
      alert('更新成功')
    } else {
      await adminCreateDeal(formData.value)
      alert('创建成功')
    }
    closeModal()
    loadDeals()
  } catch (error) {
    console.error('操作失败:', error)
    alert('操作失败: ' + (error.response?.data?.detail || error.message))
  }
}

const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  editingDeal.value = null
  formData.value = {
    title: '',
    description: '',
    original_price: null,
    deal_price: null,
    discount: null,
    category: '',
    merchant: '',
    link: '',
    image_url: '',
    coupon_code: '',
    is_active: true,
    is_featured: false
  }
}

onMounted(() => {
  loadDeals()
})
</script>

<style scoped>
.admin {
  min-height: 100vh;
  padding: 20px 0;
}

/* 登录页面样式 */
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-box {
  background: #fff;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  width: 90%;
  max-width: 400px;
  text-align: center;
}

.login-box h2 {
  color: #333;
  margin-bottom: 10px;
}

.login-box p {
  color: #666;
  margin-bottom: 30px;
}

.login-box .form-group {
  margin-bottom: 20px;
}

.login-box input {
  width: 100%;
  padding: 12px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 16px;
  box-sizing: border-box;
}

.login-box input:focus {
  outline: none;
  border-color: #667eea;
}

.login-box .btn {
  width: 100%;
  padding: 12px;
  font-size: 16px;
}

.error-msg {
  color: #f44336;
  margin-top: 15px;
  font-size: 14px;
}

.admin-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.btn-secondary {
  background: #666;
  color: #fff;
}

.btn-secondary:hover {
  background: #555;
}

.admin-header h1 {
  color: #333;
  font-size: 28px;
}

.table-container {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow-x: auto;
}

.deals-table {
  width: 100%;
  border-collapse: collapse;
}

.deals-table th,
.deals-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.deals-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
}

.deals-table tbody tr:hover {
  background: #fafafa;
}

.title-cell {
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.time-cell {
  white-space: nowrap;
  font-size: 13px;
  color: #666;
}

.price-cell {
  color: #ff6b6b;
  font-weight: bold;
}

.status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status.active {
  background: #e8f5e9;
  color: #4caf50;
}

.status.inactive {
  background: #ffebee;
  color: #f44336;
}

.status.featured {
  background: #fff3e0;
  color: #ff9800;
}

.actions {
  display: flex;
  gap: 8px;
}

.btn {
  padding: 10px 20px;
  border-radius: 6px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
}

.btn-small {
  padding: 6px 12px;
  font-size: 13px;
}

.btn-primary {
  background: #ff6b6b;
  color: #fff;
}

.btn-primary:hover {
  background: #ff5252;
}

.btn-danger {
  background: #f44336;
  color: #fff;
}

.btn-danger:hover {
  background: #d32f2f;
}

.empty-state {
  text-align: center;
  padding: 40px;
  color: #999;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: #fff;
  border-radius: 12px;
  width: 90%;
  max-width: 700px;
  max-height: 90vh;
  overflow-y: auto;
  padding: 30px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-header h2 {
  color: #333;
  font-size: 24px;
}

.close-btn {
  background: none;
  border: none;
  font-size: 32px;
  cursor: pointer;
  color: #999;
  line-height: 1;
}

.close-btn:hover {
  color: #333;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  color: #333;
  font-weight: 500;
}

.form-group input[type="text"],
.form-group input[type="number"],
.form-group input[type="url"],
.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
}

.form-group input[type="checkbox"] {
  margin-right: 8px;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 20px;
}
</style>
