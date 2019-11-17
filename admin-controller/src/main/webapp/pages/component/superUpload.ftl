<template id="superUpload">
    <div>
        <Upload ref="upload" :action="action"
                :type="type"
                :format="format"
                :multiple="multiple"
                :paste="paste"
                :data="data"
                :show-upload-list="false"
                :before-upload="handleUpload"
                :on-success="handleUploadSuccess"
                :on-format-error="handleUploadFormatError"
                :max-size="maxsize"
                :on-exceeded-size="handleMaxSize"
                :style="computedStyle">
            <i-Button v-if="simple" icon="ios-cloud-upload-outline">上传{{fileName}}</i-Button>
            <div v-if="!simple" style="width: 158px;height:158px;text-align: center;">
                <Icon type="ios-cloud-upload" size="52" color="#3399ff" style="margin-top: 35px"></Icon>
                <p>点击或拖拽上传</p>
            </div>
        </Upload>
        <div style="display: inline-block;">
            <div v-if="mode=='image'" v-for="item in list" style="display: inline-block;"
                 :key="getImageKey(item)">
                <img :src="getImageUrl(item)" :height="size" :width="size">
                <sup class="float-dot" @click="handleRemove(item)">x</sup>
            </div>
        </div>
        <Tag v-if="mode!='image' && value!=null" type="dot" closable color="primary" style="float: left"
             @on-close="handleRemove">{{ computedValue }}
        </Tag>
    </div>
</template>

<script>
    Vue.component('super-upload', {
        template: "#superUpload",
        props: {
            value: Object,
            action: String,

            draggable: Boolean,
            multiple: Boolean,
            paste: Boolean,
            data: Object,

            auto: {
                type: Boolean,
                default: true
            },
            simple: {
                type: Boolean,
                default: true
            },
            size: {
                type: Number,
                default: 158
            },
            mode: String,
            keyword: String,
            maxsize: {
                type: Number,
                default: null
            }
        },
        computed: {
            type: function () {
                if (this.simple) {
                    return 'select'
                }
                else {
                    return 'drag'
                }
            },
            format: function () {
                if (this.mode == 'image') {
                    return ['jpg', 'jpeg', 'png'];
                }

                if (this.mode == 'excel') {
                    return ['xls', 'xlsx'];
                }

                if (this.mode == 'video') {
                    return ['mp4']
                }
            },
            fileName: function () {
                if (this.mode == 'image') {
                    return '图片';
                }

                if (this.mode == 'excel') {
                    return 'Excel';
                }

                if (this.mode == 'video') {
                    return '视频'
                }
            },
            list: function () {

                if (!this.value) {
                    return [];
                }

                if (!$.isArray(this.value)) {
                    var array = [];

                    array.push(this.value);

                    return array;
                }

                return this.value;
            },
            computedStyle: function () {

                if (this.mode == 'image') {
                    if (this.simple) {
                        return 'float:left;margin-right:10px';
                    }
                    else {
                        return 'display: inline-block;';
                    }
                }
                else {
                    if (this.simple) {
                        return 'float: left;margin-right:10px';
                    }
                    else {
                        return 'float: left;width: 158px;';
                    }
                }

            },
            computedValue: function () {

                if (!this.value) {
                    return '';
                }

                if (this.value.name) {
                    return this.value.name;
                }

                if (this.value.url) {
                    return this.value.url;
                }

                return this.value;
            }
        },
        methods: {
            handleUpload: function (file) {

                if (!this.auto) {
                    this.value = file;
                    this.$emit('input', this.value);
                }

                return this.auto;
            },
            handleUploadSuccess: function (response, file, fileList) {

                if (response.success) {
                    if (this.multiple) {
                        if (!this.value) {
                            this.value = []
                        }
                        if (this.keyword) {

                            var finished = true;
                            fileList.forEach(function (t) {
                                if (t.status != 'finished') {
                                    finished = false;
                                    return;
                                }
                            });

                            if (finished) {
                                for (var i = 0; i < fileList.length; i++) {
                                    this.value.push(fileList[i].response.data[this.keyword]);
                                }

                                this.$refs.upload.clearFiles();
                            }
                        }
                        else {
                            this.value.push(response.data);
                        }

                    }
                    else {
                        if (this.keyword && this.auto) {
                            this.value = response.data[this.keyword];
                        }
                        else {
                            if (this.auto) {
                                this.value = response.data;
                            }
                        }

                    }

                    this.$emit('input', this.value);
                    this.$emit('on-success', response, file, fileList);
                }
                else {
                    this.$Message.error(response.msg);
                }
            },
            handleUploadFormatError: function () {
                this.$Message.error(this.fileName + '格式不正确');
            },
            handleMaxSize: function (file) {
                this.$Message.error('文件大小不能超过' + this.maxsize + 'kb');
            },
            upload: function (data) {
                if (data) {
                    this.$refs.upload.data = data;
                }
                else {
                    this.$refs.upload.data = null;
                }
                this.$refs.upload.post(this.value);
            },
            getImageUrl: function (item) {
                if (this.keyword) {
                    return store.imgUrl + item;
                }
                return store.imgUrl + item.url;
            },
            getImageKey: function (item) {
                if (this.keyword) {
                    return item;
                }
                return item.url;
            },
            handleRemove: function (item) {

                if (!item) {
                    this.value = null;
                    this.$emit('input', this.value);
                    return;
                }

                if ($.isArray(this.value)) {
                    this.value.splice(this.value.indexOf(item), 1);
                }
                else {
                    this.value = null;
                }

                this.$emit('input', this.value);
            },
            initDrag: function () {
                if (this.draggable) {
                    var el = this.$el.children[1];

                    var vm = this;

                    Sortable.create(el, {
                        onStart: vm.startFunc,
                        onEnd: vm.endFunc,
                        onChoose: vm.chooseFunc
                    });
                }
            },
            startFunc: function (e) {
                this.$emit('on-start', e.oldIndex);
            },
            endFunc: function (e) {

                var movedRow = this.value[e.oldIndex];

                this.value.splice(e.oldIndex, 1);
                this.value.splice(e.newIndex, 0, movedRow);

                this.$emit('input', this.value);

                this.$emit('on-end', {
                    row: movedRow,
                    from: e.oldIndex,
                    to: e.newIndex
                });
            },
            chooseFunc: function (e) {
                this.$emit('on-choose', e.oldIndex);
            }
        },
        watch: {
            value: function (val) {
                if (!this.auto && val) {
                    var name = val.name;

                    var splits = name.split('.');

                    var format = splits[splits.length - 1];

                    if ($.inArray(format, this.format) == -1) {
                        this.handleUploadFormatError();

                        this.value = null;
                        this.$emit('input', this.value);
                    }
                }
            }
        },
        mounted: function () {
            this.initDrag();
        }
    });
</script>