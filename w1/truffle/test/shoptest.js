var ShopContract = artifacts.require("ShopContract");

constract("ShopContract", function(accounts) {
    var shopInstance;
    if("ShopContract", function(){
        return ShopContract.deployed()
        .then(function(instance){
            shopInstance = instance;
            return shopInstance.get();
        }).then(function(){
            return shopInstance.get();
        }).then(function(status){
            assert.equal(status, 1);
        });
    })
});