# note:
A fork from https://github.com/forsigner/fo-modal
# fo-modal
A nice modal

[Demo](http://forsigner.com/fo-modal)

## Install

```
bower install fo-modal --save
```

### Require
[Tether](https://github.com/HubSpot/tether)

## Usage

```html
<link rel="stylesheet" href="bower_components/fo-modal/dist/css/fo-modal.css" />

<script src="bower_components/tether/dist/js/tether.js"></script>
<script src="bower_components/fo-modal/dist/js/fo-modal.js"></script>
```

```js
var app = angular.module('app', ['foModal']);

app.controller('MainCtrl', function ($scope, foModal) {

  $scope.open = function() {
    foModal.open({
      templateUrl: 'modal.html'
    });
  };

});
```

```html

<button class="btn-demo" ng-click="open()">DEMO</button>

<script id="modal.html" type="text/ng-template">
  <h2>Feature</h2>
  <ul class="list-unstyled list-feature">
    <li>Nice UI and easy customize</li>
    <li>Position middle in screen or anyWhere</li>
    <li>Api is Simple</li>
    <li>No jQuery is required</li>
    <li>{{vm.str}}</li>
  </ul>

  <button class="btn btn-default" ng-click="close()">取消</button>
  <button class="btn btn-info" ng-click="yes()">确认</button>
</script>

```
## API

Api of fo-mdal is simple but powerful.

### ``.open(options)``

Method to create and  open a modal.

**options**:

  - `templateUrl`
  - `controller`    
  - `bodyId`    
  - `bodyClass`    
  - `overlayId`    
  - `overlayClass`    
  - `animation`    
  - `overlay`    
  - `showClose`    
  - `closeByOverlay`    
  - `scope`    
  - `resolve`    


##### templateUrl {String}

```html
<script type="text/ng-template" id="templateId">
    <h1>eading</h1>
    <div>Content</div>
</script>
```

```javascript
foModal.open({ templateUrl: 'templateId' });
```

##### controller {String} | {Array} | {Object}

```javascript
foModal.open({
    template: 'template.html',
    controller: 'mainController'
});
```

or

```javascript
foModal.open({
    template: 'template.html',
    controller: ['$scope', 'otherService', function($scope, otherService) {
      // todo
    }]
});
```
