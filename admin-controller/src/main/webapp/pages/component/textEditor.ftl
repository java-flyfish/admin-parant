<template id="textEditor">
    <div :id="editorId"></div>
</template>

<script>
    Vue.component('text-editor', {
        template: "#textEditor",
        props: {
            value: {
                type: String
            }
        },
        computed: {
            editorId: function () {
                return 'editor-' + utils.guid()
            }
        },
        mounted: function () {

            var Editor = window.wangEditor;
            var parent = this;

            this.editor = new Editor('#' + this.editorId);

            this.editor.customConfig.onchange = function (html) {
                parent.$emit('input', html);
            };

            this.editor.customConfig.menus = [
                'head',  // 标题
                'bold',  // 粗体
                'fontSize',  // 字号
                'fontName',  // 字体
                'italic',  // 斜体
                'underline',  // 下划线
                'strikeThrough',  // 删除线
                'foreColor',  // 文字颜色
                'backColor',  // 背景颜色
                'link',  // 插入链接
                'list',  // 列表
                'justify',  // 对齐方式
                'quote',  // 引用
                'emoticon',  // 表情
                'image',  // 插入图片
                'table'  // 表格
                //'video',  // 插入视频
                //'code',  // 插入代码
                //'undo',  // 撤销
                //'redo'  // 重复
            ];

            this.editor.customConfig.zIndex = 0;

            this.editor.create();

            var html = this.value;
            if (html) this.editor.txt.html(html)

        },
        watch: {
            value: function (val) {
                if (val != null) {
                    this.editor.txt.html(val)
                }
            }
        }
    });
</script>