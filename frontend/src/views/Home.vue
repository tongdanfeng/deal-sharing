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
                @click="copyLink(deal.link)" 
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

const copyLink = async (link) => {
  try {
    await navigator.clipboard.writeText(link)
    alert('链接已复制到剪贴板！')
  } catch (err) {
    // 降级方案：使用传统方法复制
    const textArea = document.createElement('textarea')
    textArea.value = link
    textArea.style.position = 'fixed'
    textArea.style.left = '-999999px'
    document.body.appendChild(textArea)
    textArea.select()
    try {
      document.execCommand('copy')
      alert('链接已复制到剪贴板！')
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
  padding: 20px 0;
}

.filter-section {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.filter-section h2 {
  margin-bottom: 15px;
  color: #333;
  font-size: 20px;
}

.category-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.tag {
  padding: 8px 16px;
  background: #f0f0f0;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 14px;
}

.tag:hover {
  background: #ff6b6b;
  color: #fff;
}

.tag.active {
  background: #ff6b6b;
  color: #fff;
}

.deals-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.deal-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
  position: relative;
}

.deal-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.featured-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: #ff6b6b;
  color: #fff;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
  z-index: 10;
}

.deal-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f5f5f5;
}

.deal-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.deal-content {
  padding: 20px;
}

.deal-title {
  font-size: 18px;
  color: #333;
  margin-bottom: 10px;
  line-height: 1.4;
}

.deal-description {
  color: #666;
  font-size: 14px;
  margin-bottom: 15px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.deal-prices {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.original-price {
  color: #999;
  text-decoration: line-through;
  font-size: 14px;
}

.deal-price {
  color: #ff6b6b;
  font-size: 24px;
  font-weight: bold;
}

.discount {
  background: #fff3e0;
  color: #ff9800;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.deal-meta {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
  font-size: 13px;
  color: #666;
  flex-wrap: wrap;
}

.deal-meta .time {
  color: #999;
  font-size: 12px;
}

.deal-actions {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.btn {
  padding: 10px 20px;
  border-radius: 6px;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s;
  cursor: pointer;
  border: none;
}

.btn-primary {
  background: #ff6b6b;
  color: #fff;
}

.btn-primary:hover {
  background: #ff5252;
}

.btn-copy {
  background: #4caf50;
  color: #fff;
}

.btn-copy:hover {
  background: #45a049;
}

.coupon-code {
  background: #e3f2fd;
  color: #1976d2;
  padding: 6px 12px;
  border-radius: 4px;
  font-size: 13px;
  font-family: monospace;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}
</style>
