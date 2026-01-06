<template>
  <div class="uptime">
    <span>{{ days }}</span> 天
    <span>{{ hours }}</span> 时
    <span>{{ mins }}</span> 分
    <span>{{ secs }}</span> 秒
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import config from '@/config.js' // 引入你的配置文件

// 从 config.js 读取 launchTime，若未设置则使用默认值（可选）
const launchTimeString = config.launchTime || '2024-01-01T00:00:00'
const startTime = new Date(launchTimeString)

// 安全检查：如果时间无效，显示错误
if (isNaN(startTime.getTime())) {
  console.error('[Uptime.vue] 配置的 launchTime 格式无效，请使用 ISO 8601 格式，例如 "2025-12-07T00:00:00"')
}

const now = ref(Date.now())
let timer = null

onMounted(() => {
  // 每秒更新一次当前时间
  timer = setInterval(() => {
    now.value = Date.now()
  }, 1000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

// 计算时间差（单位：秒）
const diffSeconds = computed(() => {
  const diff = now.value - startTime.getTime()
  return Math.max(0, Math.floor(diff / 1000)) // 确保不为负数
})

const days = computed(() => Math.floor(diffSeconds.value / 86400))
const hours = computed(() => Math.floor((diffSeconds.value % 86400) / 3600))
const mins = computed(() => Math.floor((diffSeconds.value % 3600) / 60))
const secs = computed(() => diffSeconds.value % 60)
</script>

<style scoped>
.uptime {
  font-size: 0.9rem;
  opacity: 0.8;
  letter-spacing: 1px;
}
.uptime span {
  color: var(--leleo-vcard-color);
  font-weight: bold;
}
</style>