var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope,$http) {
    $scope.firstName= "John";
    $scope.lastName= "Doe";
     $scope.names = ["项目一", "项目二", "项目三"];
     $scope.selectedName="";
    // console.log("hhh  ~~~~~~~~~");
    $scope.tableItems = $http.get("http://www.runoob.com/try/angularjs/data/Customers_JSON.php")
    .success(function (response) {$scope.names = response.records;});

    $scope.toggle = function() {
        // console.log("do something  ~~~~~~~~~");
    };
});
