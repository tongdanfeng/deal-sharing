import axios from 'axios'

const api = axios.create({
  baseURL: 'https://deal-sharing-backend.onrender.com/api',
  timeout: 10000
})

// 获取优惠列表
export const getDeals = (params = {}) => {
  return api.get('/deals', { params })
}

// 获取单个优惠详情
export const getDeal = (id) => {
  return api.get(`/deals/${id}`)
}

// 获取所有分类
export const getCategories = () => {
  return api.get('/categories')
}

// 后台 - 获取所有优惠
export const adminGetDeals = (params = {}) => {
  return api.get('/admin/deals', { params })
}

// 后台 - 创建优惠
export const adminCreateDeal = (data) => {
  return api.post('/admin/deals', data)
}

// 后台 - 更新优惠
export const adminUpdateDeal = (id, data) => {
  return api.put(`/admin/deals/${id}`, data)
}

// 后台 - 删除优惠
export const adminDeleteDeal = (id) => {
  return api.delete(`/admin/deals/${id}`)
}

export default api
