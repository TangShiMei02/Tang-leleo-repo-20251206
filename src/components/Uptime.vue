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
import config from '../config.js' // ← 改成相对路径！

const launchTimeString = config.launchTime || '2024-01-01T00:00:00'
const startTime = new Date(launchTimeString)

if (isNaN(startTime.getTime())) {
  console.error('[Uptime.vue] 配置的 launchTime 格式无效，请使用 ISO 8601 格式，例如 "2025-12-07T00:00:00"')
}

const now = ref(Date.now())
let timer = null

onMounted(() => {
  timer = setInterval(() => {
    now.value = Date.now()
  }, 1000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

const diffSeconds = computed(() => {
  const diff = now.value - startTime.getTime()
  return Math.max(0, Math.floor(diff / 1000))
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