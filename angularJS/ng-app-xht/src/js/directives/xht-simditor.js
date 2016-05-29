'use strict';

// @ngInject
export default ($location, $timeout, simditorOptions) => {


    return {
        // name: '',
        // priority: 1,
        // terminal: true, 
        scope: {
            content: '='
        }, // {} = isolate, true = child, false/undefined = no change
        controller: controller,
        // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
        restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
        template: '<textarea data-autosave="editor-content" autofocus></textarea>',
        // templateUrl: '',
        replace: true,
        // transclude: true,
        // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
        link: function($scope, iElm, iAttrs, controller) {

            var config = angular.extend({
                textarea: iElm,
                toolbar: ['title', 'bold', 'italic', 'underline', 'strikethrough', 'color', '|', 'ol', 'ul', 'blockquote', 'code', 'table', '|', 'link', 'image', 'hr', '|', 'indent', 'outdent', 'alignment', '|', 'html'],
                placeholder: '这里输入文字啊1...',
                pasteImage: true,
                defaultImage: '',
                upload: {
                    url: '/upload'
                },
                allowedTags: ['br', 'a', 'img', 'b', 'strong', 'i', 'u', 'font', 'p', 'ul', 'ol', 'li', 'blockquote', 'pre', 'h1', 'h2', 'h3', 'h4', 'hr', 'div', 'script', 'style']
            }, simditorOptions);

            var editor = new Simditor(config);

            var nowContent = '';

            $scope.$watch('content', function(value, old) {
                if (typeof value !== 'undefined' && value != nowContent) {
                    editor.setValue(value);
                }
            });

            editor.on('valuechanged', function(e) {
                if ($scope.content != editor.getValue()) {
                    $timeout(function() {
                        $scope.content = nowContent = editor.getValue();
                    });
                }
            });
        }
    };

    // @ngInject
    function controller($location) {
        let vm = this;
    }

};