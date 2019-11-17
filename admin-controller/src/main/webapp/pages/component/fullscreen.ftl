<template id="fullscreen">
    <div v-if="showFullScreenBtn">
        <Tooltip :content="value ? '退出全屏' : '全屏'" placement="bottom">
            <Icon style="color: white;cursor: pointer;" @click.native="handleFullscreen"
                  :type="value ? 'md-contract' : 'md-expand'" :size="23"></Icon>
        </Tooltip>
    </div>
</template>

<script>
    Vue.component('fullscreen', {
        template: "#fullscreen",
        props: {
            value: {
                type: Boolean,
                default: false
            }
        },
        computed: {
            showFullScreenBtn: function () {
                return window.navigator.userAgent.indexOf('MSIE') < 0
            }
        },
        methods: {
            handleFullscreen: function () {
                var main = document.body;
                if (this.value) {
                    if (document.exitFullscreen) {
                        document.exitFullscreen()
                    } else if (document.mozCancelFullScreen) {
                        document.mozCancelFullScreen()
                    } else if (document.webkitCancelFullScreen) {
                        document.webkitCancelFullScreen()
                    } else if (document.msExitFullscreen) {
                        document.msExitFullscreen()
                    }
                    this.value = false;
                } else {
                    if (main.requestFullscreen) {
                        main.requestFullscreen()
                    } else if (main.mozRequestFullScreen) {
                        main.mozRequestFullScreen()
                    } else if (main.webkitRequestFullScreen) {
                        main.webkitRequestFullScreen()
                    } else if (main.msRequestFullscreen) {
                        main.msRequestFullscreen()
                    }
                    this.value = true;
                }
            }
        }
    });
</script>