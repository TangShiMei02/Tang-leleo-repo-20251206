<template>
  <div class="uptime">
     <span>{{ days }}</span> 天 <span>{{ hours }}</span> 时 <span>{{ mins }}</span> 分 <span>{{ secs }}</span> 秒
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

// 优先读环境变量，没有就用 build 时间（本地开发场景）
const start = new Date(import.meta.env.VITE_START_TIME || __BUILD_TIME__)
const now = ref(Date.now())

let timer = null
onMounted(() => { timer = setInterval(() => now.value = Date.now(), 1000) })
onUnmounted(() => clearInterval(timer))

const diff = computed(() => Math.floor((now.value - start) / 1000)) // 秒
const days  = computed(() => Math.floor(diff.value / 86400))
const hours = computed(() => Math.floor((diff.value % 86400) / 3600))
const mins  = computed(() => Math.floor((diff.value % 3600) / 60))
const secs  = computed(() => diff.value % 60)
</script>

<style scoped>
.uptime{ font-size: .9rem; opacity: .8; letter-spacing: 1px; }
.uptime span{ color: var(--leleo-vcard-color); font-weight: bold; }
</style>