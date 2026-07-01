<template>
  <div class="home">
    <div class="container">
      <!-- 分类筛选 -->
      <div class="filter-section">
        <h2>优惠分类</h2>
        <div class="category-tags">
          <span 
            class="tag" 
            :class="{ active: !selectedCategory }"
            @click="selectedCategory = null"
          >
            全部
          </span>
          <span 
            v-for="cat in categories" 
            :key="cat"
            class="tag"
            :class="{ active: selectedCategory === cat }"
            @click="selectedCategory = cat"
          >
            {{ cat }}
          </span>
        </div>
      </div>

      <!-- 优惠列表 -->
      <div class="deals-grid">
        <div v-for="deal in deals" :key="deal.id" class="deal-card">
          <div v-if="deal.is_featured" class="featured-badge">推荐</div>
          <div class="deal-image" v-if="deal.image_url">
            <img :src="deal.image_url" :alt="deal.title" />
          </div>
          <div class="deal-content">
            <h3 class="deal-title">{{ deal.title }}</h3>
            <p class="deal-description">{{ deal.description }}</p>
            
            <div class="deal-prices">
              <span v-if="deal.original_price" class="original-price">
                ¥{{ deal.original_price.toFixed(2) }}
              </span>
              <span v-if="deal.deal_price" class="deal-price">
                ¥{{ deal.deal_price.toFixed(2) }}
              </span>
              <span v-if="deal.discount" class="discount">
                {{ deal.discount }}折
              </span>
            </div>

            <div class="deal-meta">
              <span v-if="deal.merchant" class="merchant">🏪 {{ deal.merchant }}</span>
              <span v-if="deal.category" class="category">📦 {{ deal.category }}</span>
              <span class="time">🕒 {{ formatTime(deal.created_at) }}</span>
            </div>

            <div class="deal-actions">
              <a 
                v-if="deal.link" 
                :href="deal.link" 
                target="_blank" 
                class="btn btn-primary"
              >
                立即购买
              </a>
              <button 
                v-if="deal.link" 
                @click="copyLink(deal)" 
                class="btn btn-copy"
              >
                📋 复制链接
              </button>
              <span v-if="deal.coupon_code" class="coupon-code">
                优惠码: {{ deal.coupon_code }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div v-if="deals.length === 0" class="empty-state">
        <p>暂无优惠信息，敬请期待！</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { getDeals, getCategories } from '../api'

const deals = ref([])
const categories = ref([])
const selectedCategory = ref(null)

const loadDeals = async () => {
  try {
    const params = {}
    if (selectedCategory.value) {
      params.category = selectedCategory.value
    }
    const response = await getDeals(params)
    deals.value = response.data
  } catch (error) {
    console.error('加载优惠列表失败:', error)
  }
}

const loadCategories = async () => {
  try {
    const response = await getCategories()
    categories.value = response.data
  } catch (error) {
    console.error('加载分类失败:', error)
  }
}

const formatTime = (timeStr) => {
  if (!timeStr) return ''
  const date = new Date(timeStr)
  const now = new Date()
  const diff = now - date
  
  // 小于1分钟
  if (diff < 60000) {
    return '刚刚'
  }
  // 小于1小时
  if (diff < 3600000) {
    return Math.floor(diff / 60000) + '分钟前'
  }
  // 小于24小时
  if (diff < 86400000) {
    return Math.floor(diff / 3600000) + '小时前'
  }
  // 小于7天
  if (diff < 604800000) {
    return Math.floor(diff / 86400000) + '天前'
  }
  // 其他情况显示具体日期
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}`
}

const copyLink = async (deal) => {
  try {
    // 组合复制内容：标题 + 描述 + 链接
    let content = `🔥 ${deal.title}\n`
    if (deal.description) {
      content += `📝 ${deal.description}\n`
    }
    content += `🔗 ${deal.link}`
    await navigator.clipboard.writeText(content)
    alert('优惠信息已复制到剪贴板！')
  } catch (err) {
    // 降级方案：使用传统方法复制
    let content = `🔥 ${deal.title}\n`
    if (deal.description) {
      content += `📝 ${deal.description}\n`
    }
    content += `🔗 ${deal.link}`
    const textArea = document.createElement('textarea')
    textArea.value = content
    textArea.style.position = 'fixed'
    textArea.style.left = '-999999px'
    document.body.appendChild(textArea)
    textArea.select()
    try {
      document.execCommand('copy')
      alert('优惠信息已复制到剪贴板！')
    } catch (error) {
      alert('复制失败，请手动复制')
    }
    document.body.removeChild(textArea)
  }
}

onMounted(() => {
  loadDeals()
  loadCategories()
})

watch(selectedCategory, () => {
  loadDeals()
})
</script>

<style scoped>
.home {
  min-height: 100vh;
  padding: 30px 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.filter-section {
  background: rgba(255, 255, 255, 0.95);
  padding: 25px;
  border-radius: 16px;
  margin-bottom: 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
}

.filter-section h2 {
  margin-bottom: 18px;
  color: #2d3748;
  font-size: 22px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-section h2::before {
  content: '🏷️';
  font-size: 24px;
}

.category-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.tag {
  padding: 10px 20px;
  background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
  font-weight: 500;
  color: #4a5568;
  border: 2px solid transparent;
}

.tag:hover {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.tag.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  border-color: #fff;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.deals-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 25px;
}

.deal-card {
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.deal-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}

.featured-badge {
  position: absolute;
  top: 15px;
  right: 15px;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: #fff;
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: bold;
  z-index: 10;
  box-shadow: 0 4px 12px rgba(245, 87, 108, 0.4);
}

.deal-image {
  width: 100%;
  height: 220px;
  overflow: hidden;
  background: linear-gradient(135deg, #e0e7ff 0%, #f0f4ff 100%);
}

.deal-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s;
}

.deal-card:hover .deal-image img {
  transform: scale(1.1);
}

.deal-content {
  padding: 25px;
}

.deal-title {
  font-size: 20px;
  color: #2d3748;
  margin-bottom: 12px;
  line-height: 1.5;
  font-weight: 700;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.deal-description {
  color: #718096;
  font-size: 15px;
  margin-bottom: 18px;
  line-height: 1.7;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.deal-prices {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 18px;
  flex-wrap: wrap;
  padding: 15px;
  background: linear-gradient(135deg, #fff5f5 0%, #fed7d7 100%);
  border-radius: 12px;
}

.original-price {
  color: #a0aec0;
  text-decoration: line-through;
  font-size: 15px;
  font-weight: 500;
}

.deal-price {
  color: #e53e3e;
  font-size: 28px;
  font-weight: 800;
  text-shadow: 0 2px 4px rgba(229, 62, 62, 0.1);
}

.discount {
  background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
  color: #fff;
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: bold;
  box-shadow: 0 2px 8px rgba(245, 158, 11, 0.3);
}

.deal-meta {
  display: flex;
  gap: 18px;
  margin-bottom: 18px;
  font-size: 14px;
  color: #718096;
  flex-wrap: wrap;
  padding: 12px;
  background: #f7fafc;
  border-radius: 10px;
}

.deal-meta span {
  display: flex;
  align-items: center;
  gap: 4px;
}

.deal-meta .time {
  color: #a0aec0;
  font-size: 13px;
}

.deal-actions {
  display: flex;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.btn {
  padding: 12px 24px;
  border-radius: 12px;
  text-decoration: none;
  font-size: 15px;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  border: none;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.btn-primary {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: #fff;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #f5576c 0%, #ee5a6f 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(245, 87, 108, 0.4);
}

.btn-copy {
  background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
  color: #fff;
}

.btn-copy:hover {
  background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(56, 161, 105, 0.4);
}

.coupon-code {
  background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
  color: #4c51bf;
  padding: 8px 16px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  font-family: 'Courier New', monospace;
  box-shadow: 0 2px 8px rgba(79, 70, 229, 0.2);
}

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 18px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  backdrop-filter: blur(10px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .deals-grid {
    grid-template-columns: 1fr;
  }
  
  .deal-card:hover {
    transform: translateY(-4px);
  }
}
</style>
