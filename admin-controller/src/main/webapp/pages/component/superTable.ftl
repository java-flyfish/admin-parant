<template id="superTable">
    <i-table highlight-row :columns="columns" :data="data" :height="height" :loading="loading"
             @on-current-change="tableRowChange"></i-table>
</template>

<script>
    Vue.component('super-table', {
        template: "#superTable",
        props: {
            columns: Array,
            data: Array,
            height: Number,
            loading: Boolean,
            handle: String,
            draggable: Boolean,
            editable: Boolean,
            container: {
                type: String,
                default: '.layout-body-content'
            }
        },
        methods: {
            startFunc: function (e) {
                this.$emit('on-start', e.oldIndex);
            },
            endFunc: function (e) {
                var movedRow = this.data[e.oldIndex];
                this.data.splice(e.oldIndex, 1);
                this.data.splice(e.newIndex, 0, movedRow);
                this.$emit('on-end', {
                    row: movedRow,
                    from: e.oldIndex,
                    to: e.newIndex
                });
            },
            chooseFunc: function (e) {
                this.$emit('on-choose', e.oldIndex);
            },
            tableRowChange: function (currentRow) {
                this.$emit('on-current-change', currentRow);
            },
            initDrag: function () {
                if (this.draggable) {

                    var el = this.$children[0].$children[1].$el.children[1];

                    var vm = this;

                    if (this.handle) {
                        Sortable.create(el, {
                            onStart: vm.startFunc,
                            onEnd: vm.endFunc,
                            onChoose: vm.chooseFunc,
                            handle: vm.handle
                        });
                    }
                    else {
                        Sortable.create(el, {
                            onStart: vm.startFunc,
                            onEnd: vm.endFunc,
                            onChoose: vm.chooseFunc
                        });
                    }
                }
            },
            initEdit: function () {
                if (this.editable) {
                    var vm = this;
                    this.columns.forEach(function (item) {

                        if (item.plugin) {
                            item.render = function (h, params) {

                                if (item.plugin.type == 'Input') {
                                    return h('Input', {
                                        props: {
                                            value: params.row[params.column.key]
                                        },
                                        on: {
                                            'input': function (val) {
                                                params.row[params.column.key] = val;
                                            },
                                            'on-blur': function () {
                                                vm.data[params.index][params.column.key] = params.row[params.column.key];
                                            }
                                        }
                                    })
                                }

                                if (item.plugin.type == 'InputNumber') {
                                    return h('InputNumber', {
                                        props: {
                                            value: params.row[params.column.key],
                                            min: 0
                                        },
                                        style: {
                                            width: '100%'
                                        },
                                        on: {
                                            'input': function (val) {
                                                params.row[params.column.key] = val;
                                            },
                                            'on-blur': function () {
                                                vm.data[params.index][params.column.key] = params.row[params.column.key];
                                            }
                                        }
                                    })
                                }

                                if (item.plugin.type == 'Select') {
                                    if (item.plugin.data && item.plugin.data.length != 0) {
                                        var opts = [];

                                        item.plugin.data.forEach(function (t) {
                                            opts.push(h('Option', {
                                                props: {
                                                    value: t.value
                                                }
                                            }, t.label));
                                        });

                                        return h('Select', {
                                            props: {
                                                value: params.row[params.column.key]
                                            },
                                            on: {
                                                'on-change': function (value) {
                                                    vm.data[params.index][params.column.key] = value;
                                                }
                                            }
                                        }, opts);
                                    }
                                }
                            }
                        }

                    })

                }
            },
            initHeight: function () {
                var vm = this;

                this.$nextTick(function () {
                    if (this.container) {
                        this.height = $(this.container).height();

                        $(this.container).resize(function () {
                            vm.$forceUpdate();
                        });
                    }

                });

            },
            initFormat: function () {
                this.columns.forEach(function (item) {
                    if (item.format) {
                        item.render = function (h, params) {
                            if (item.format == 'Boolean') {
                                return h('div', params.row[params.column.key] ? '是' : '否')
                            }

                            if (item.format == 'Time') {
                                return h('div', utils.dateFormat(params.row[params.column.key]))
                            }
                        }
                    }
                })
            }
        },
        created: function () {
            this.initEdit();

            this.initFormat();
        },
        mounted: function () {
            this.initDrag();

            this.initHeight();
        },
        updated: function () {
            if (this.container) {
                if (this.height != $(this.container).height() && $(this.container).height() != 0) {
                    this.height = $(this.container).height();
                }

            }
        },
        watch: {
            columns: function () {
                this.initEdit();

                this.initFormat();
            }
        }
    });
</script>