function hibbnTouch() {
    document.body.addEventListener('touchmove', function(event) {
        event.preventDefault();
    }, false);
}

function loadCSS(filename) {
    var fileref = document.createElement("link")
    fileref.setAttribute("rel", "stylesheet")
    fileref.setAttribute("type", "text/css")
    fileref.setAttribute("href", filename)

    if (typeof fileref != "undefined")
        document.getElementsByTagName("head")[0].appendChild(fileref)
}

function documentClick() {
    document.ontouchend = function() {
        window.location.href = "kingsoft://documentclick/";
    };
}

function setMargin(percentage) {
    document.getElementById("widget").style.marginTop = percentage + "%";
    loadUrlCss();
}

function login() {
    var account = encodeURIComponent(document.getElementById('account').value);
    var pwd = encodeURIComponent(document.getElementById('pwd').value);
    window.location.href = "kingsoft://login/?account=" + account + "&pwd=" + pwd;
}

function setBottomAdUrl(url_param) {
    document.querySelector('#bottom_gg_dom').style.display = 'block';
    document.querySelector('#bottom_gg_iframe').src = url_param;
}

function logout() {
    window.location.href = "kingsoft://logout/";
}

function quickLogin() {
    window.location.href = "kingsoft://quickLogin/";
}

function registerPhonePage() {
    window.location.href = "kingsoft://registerPhonePage/";
}

function forgetPwdPage() {
    var account = encodeURIComponent(document.getElementById('account').value);
    window.location.href = "kingsoft://forgetPwdPage/?account=" + account;
}

function closesPage() {
    window.location.href = "kingsoft://closesPage/";
}

function setLanguage(lan) {
    window.location.href = "kingsoft://setLanguage/?language=" + lan; //key名称不重要，要注意key＝之后没有空格
}

function backPage() {
    window.location.href = "kingsoft://backPage/";
}

function sendMsg() {
    var phoneNumber = encodeURIComponent(document.getElementById('phoneNumber').value);
    window.location.href = "kingsoft://sendMsg/?phoneNumber=" + phoneNumber;
}

function reSendMsg() {
    window.location.href = "kingsoft://reSendMsg/";
}

function registerPassportPage() {
    window.location.href = "kingsoft://registerPassportPage/";
}

function registerPassport() {
    var account = encodeURIComponent(document.getElementById('account').value);
    var pwd = encodeURIComponent(document.getElementById('pwd').value);
    var protocol = encodeURIComponent(document.getElementById("inputAgreement").checked);
    window.location.href = "kingsoft://registerPassport/?account=" + account + "&pwd=" + pwd + "&protocol=" + encodeURIComponent(protocol);
}



function registerPhone() {
    var captcha = encodeURIComponent(document.getElementById('captcha').value);
    var pwd = encodeURIComponent(document.getElementById('pwd').value);
    var protocol = encodeURIComponent(document.getElementById("inputAgreement").checked);
    window.location.href = "kingsoft://registerPhone/?captcha=" + captcha + "&pwd=" + pwd + "&protocol=" + protocol;
}

function forgetPwd() {
    var account = encodeURIComponent(document.getElementById('account').value);
    window.location.href = "kingsoft://forgetPwd/?account=" + account;
}

function resetPwd() {
    var captcha = encodeURIComponent(document.getElementById('captcha').value);
    var pwd = encodeURIComponent(document.getElementById('pwd').value);
    window.location.href = "kingsoft://resetPwd/?captcha=" + captcha + "&pwd=" + pwd;
}

function checkAgreement() {
    if (document.getElementById("inputAgreement").checked) {
        document.getElementById("inputAgreement").checked = false;
    } else {
        document.getElementById("inputAgreement").checked = true;
    }

}

function AgreementLink() {
    window.location.href = "kingsoft://AgreementLink/";
}

function callPhone() {
    window.location.href = "kingsoft://callPhone/";
}

function connentPhonePage() {
    window.location.href = "kingsoft://connentPhonePage/";
}

function connentPassportPage() {
    window.location.href = "kingsoft://connentPassportPage/";
}

function setReSendText(text) {
    document.querySelector('#resend').value = text;
    document.querySelector('#resend').innerHTML = text;
}

function setReSendDelay(enable) {
    if (enable == true) {
        document.getElementById('resend').style.background = "url(../resend_delay.png) no-repeat";
        document.getElementById('resend').style.backgroundSize = "100%100%";
    } else {
        document.getElementById('resend').style.background = "url(../resend_button.png) no-repeat";
        document.getElementById('resend').style.backgroundSize = "100%100%";
    }

}

function connentPhone() {
    var phoneNumber = getValueById('phoneNumber');
    var captcha = encodeURIComponent(document.getElementById('captcha').value);
    var pwd = encodeURIComponent(document.getElementById('pwd').value);
    window.location.href = "kingsoft://connentPhone/?captcha=" + captcha + "&pwd=" + pwd + "&phoneNumber=" + phoneNumber;

}

function setAccount(text) {
    var account = document.querySelector('#account');
    account.setAttribute('value', text);
    account.innerHTML = text;
}

function setPhoneNumber(text) {
    document.getElementById('phoneNumber').value = text;
}

function setPwd(text) {
    document.getElementById('pwd').value = text;
    document.getElementById('pwd').innerHTML = text;
}

function setTimerMsg(text) {
    document.getElementById('timerMsg').value = text;
    document.getElementById('timerMsg').innerHTML = text;
}

function setProductInfo(name, price, doc) {
    document.getElementById('pName').innerHTML = name;
    document.getElementById('pPrice').innerHTML = price;
    document.getElementById('pDoc').innerHTML = doc;
}

function setSubmitText(text) {
    document.getElementById('submit').value = text;
}

function setMsgTitle(text) {
    document.getElementById('msgTitle').innerHTML = text;
}

function setMsgContext(text) {
    document.getElementById('msgContext').innerHTML = text;
}

function setCancelBtnText(text) {
    document.getElementById('cancelBtn').value = text;
}

function setConfirmBtnText(text) {
    document.getElementById('confirmBtn').value = text;
}

function alipay() {
    window.location.href = "kingsoft://alipay/";
}

function wxpay() {
    window.location.href = "kingsoft://wxpay/";
}

function bankpay() {
    window.location.href = "kingsoft://bankpay/";
}

function jdpay() {
    window.location.href = "kingsoft://jdpay/";
}

function mobilepay() {
    window.location.href = "kingsoft://mobilepay/";
}

function setDisplayAlipay(enable) {
    if (enable == true) {
        document.getElementById('alipayBtn').style.display = 'inline-block';
    } else {
        document.getElementById('alipayBtn').style.display = 'none';
    }
}

function setDisplayWxpay(enable) {
    if (enable == true) {
        document.getElementById('wxpayBtn').style.display = 'inline-block';
    } else {
        document.getElementById('wxpayBtn').style.display = 'none';
    }
}

function setDisplayBankpay(enable) {
    if (enable == true) {
        document.getElementById('bankpayBtn').style.display = 'inline-block';
    } else {
        document.getElementById('bankpayBtn').style.display = 'none';
    }
}

function setDisplayJdpay(enable) {
    if (enable == true) {
        document.getElementById('jdpayBtn').style.display = 'inline-block';
    } else {
        document.getElementById('jdpayBtn').style.display = 'none';
    }
}

function setDisplayMobilepay(enable) {
    if (enable == true) {
        document.getElementById('mobilepayBtn').style.display = 'inline-block';
    } else {
        document.getElementById('mobilepayBtn').style.display = 'none';
    }
}

function setDisplayConnentPhone(enable) {
    if (enable == true) {
        document.getElementById('connentPhone').style.display = 'inline-block';
    } else {
        document.getElementById('connentPhone').style.display = 'none';
    }
}

function setConnectPhone(text) {
    document.querySelector('#connentPhone').setAttribute('value', text);
}

function setDisplayConnentPassport(enable) {
    if (enable == true) {
        document.getElementById('connentPassport').style.display = 'inline-block';
    } else {
        document.getElementById('connentPassport').style.display = 'none';
    }
}

function setDisplaySubmit(enable) {
    if (enable == true) {
        document.getElementById('submit').style.display = 'inline-block';
    } else {
        document.getElementById('submit').style.display = 'none';
    }
}

function setOnLockPhoneNumber(enable) {
    if (enable == true) {
        document.getElementById('phoneNumber').disabled = true;
    } else {
        document.getElementById('phoneNumber').disabled = false;
    }
}

function setDisplayQuickLogin(enable) {
    if (enable == false) {
        document.getElementById("register").style.width = "100%";
        document.getElementById("quick").style.display = "none";
        document.getElementById("vLine").style.display = "none";
    }
}

function setDisplayMobileDollar() {
    showAllDollar();
    document.querySelector('label[for=twoHundred]').style.display = 'none';
}

function setDisplayUnciomDollar() {
    showAllDollar();
    document.querySelector('label[for=ten]').style.display = 'none';
    document.querySelector('label[for=twoHundred]').style.display = 'none';
    document.querySelector('input[id=twenty]').checked = true;
}

function setDisplayCDMADollar() {
    showAllDollar();
}

function showAllDollar() {
    document.querySelector('input[id=ten]').checked = true;
    var label = document.getElementsByTagName('label');
    for (var i = 0; i < label.length; i++) {
        label[i].style.display = 'inline-block';
    }
}

function MPayInputPage() {
    var telco = document.getElementsByName('telco');
    var dollar = document.getElementsByName('dollar');
    var type = 0;
    var money = 0;

    for (var i = 0; i < telco.length; i++) {
        if (telco[i].checked) {
            type = telco[i].value;
            break;
        }
    }

    for (var i = 0; i < dollar.length; i++) {
        if (dollar[i].checked) {
            money = dollar[i].value;
            break;
        }
    }

    window.location.href = "kingsoft://MPayInputPage/?type=" + type + "&money=" + money;
}

function setTelco(type) {
    var telco = document.getElementsByName('telco');
    telco[type].checked = true;

    if (type == 0) {
        setDisplayMobileDollar();
    } else if (type == 1) {
        setDisplayUnciomDollar();
    } else {
        setDisplayCDMADollar();
    }
}

function setTelcoDollar(money) {
    var dollar = document.getElementsByName('dollar');
    for (var i = 0; i < dollar.length; i++) {
        if (dollar[i].value == money) {
            dollar[i].checked = true;
            break;
        }
    }
}

//卡號密碼
function MPayConfirmPage() {
    var number = getValueById('cardNumber');
    var pwd = getValueById('cardPwd');
    window.location.href = "kingsoft://MPayConfirmPage/?cardNumber=" + number + "&cardPwd=" + pwd;
}

function MPay() {
    window.location.href = "kingsoft://MPay/";
}

function setDollar(num) {
    var flag = document.getElementsByName('spDollar');

    for (var i = flag.length - 1; i >= 0; i--) {
        flag[i].innerHTML = num;
    };
}

function backPaymentPage() {
    window.location.href = "kingsoft://backPaymentPage/";
}

function MPayRetry() {
    window.location.href = "kingsoft://MPayRetry/";
}

function refreshCaptcha() {
    window.location.href = "kingsoft://refreshCaptcha/";
}

function setCaptchaImg(url) {
    document.getElementById('captchaImg').src = url + '&_=' + new Date().getTime();
}

function onConfirmCaptcha() {
    var captcha = getValueById('captcha');
    window.location.href = "kingsoft://onConfirm/?captcha=" + captcha;
}

function cleanUP() {
    document.getElementById('captcha').value = "";
}

function onCancel() {
    window.location.href = "kingsoft://onCancel/";
}

function onConfirm() {
    window.location.href = "kingsoft://onConfirm/";
}

function getValueById(id) {
    return encodeURIComponent(document.querySelector('#' + id).value);
}


function getAllInputInfo() {
    var list = document.getElementsByTagName("input");

    var strData = "{";
    //对表单中所有的input进行遍历
    for (var i = 0; i < list.length; i++) {
        //判断是否为文本 或者 是密码
        if (list[i].type == "text" || list[i].type == "password") {
            if (strData != "{") {
                strData += ",";
            }
            var listValue = list[i].value;
            if (!listValue) {
                listValue = "";
            }
            strData += "\"" + list[i].id + "\"" + ": \"" + listValue + "\"";
        }
    }
    strData += "}";
    console.log(strData);
    return strData;
}

function convertInputInfo(infos) {
    var infosJsonObj = eval('(' + infos + ')');

    for (var id in infosJsonObj) {
        document.getElementById(id).value = infosJsonObj[id]
    }
}

function setThirdParyDisplay(media, display) {
    if (display) {
        document.getElementById(media).style.display = 'inline';
    } else {
        document.getElementById(media).style.display = 'none';
    }
}

function loginwith(type) {
    window.location.href = "kingsoft://loginwith/?type=" + type;
} 

//--xoyobox_html-----
function xoyobox_registerPassport() {
    window.location.href = "kingsoft://xoyobox_registerPassport/";
}


function xoyobox_registerPhonePage() {
    window.location.href = "kingsoft://xoyobox_registerPhonePage/";
}

function xoyobox_registerPassportSure() {
    var account = getValueById('account');
    var pwd = getValueById('pwd');
    var cpwd = getValueById('cpwd');
    window.location.href = "kingsoft://xoyobox_registerPassportSure/?account=" + account + "&pwd=" + pwd + "&cpwd=" + cpwd;
}

function xoyobox_sendPhoneNumber() {
    var countyNum = getValueById('countryNum');
    var phoneNumber = getValueById('phoneNumber');

    window.location.href = "kingsoft://xoyobox_sendMsg/?phoneNumber=" + phoneNumber + "&countryCode=" + countyNum;
}

function xoyobox_registerPhone() {
    var captcha = getValueById('phoneCode');
    var pwd = getValueById('pwd');
    window.location.href = "kingsoft://registerPhone/?captcha=" + captcha + "&pwd=" + pwd + "&protocol=1";
}

function xoyobox_bindAccount() {
    window.location.href = "kingsoft://xoyobox_bindAccount/";
}



function xoyobox_immRecharge() {
    window.location.href = "kingsoft://xoyobox_immRecharge/";
}

function xoyobox_bindNewAccount() {
    window.location.href = "kingsoft://xoyobox_bindNewAccount/";
}

function xoyobox_clearAccountPwd() {
    document.getElementById('account').value = "";
    document.getElementById('pwd').value = "";
}

function setTimerCount(text) {
    document.getElementById('timerCount').value = text;
    document.getElementById('timerCount').innerHTML = text;
}

function reload() {
    window.location.href = "kingsoft://reload/";
}

function setConnentPhoneText(text) {
    document.getElementById('connentPhone').value = text;
}

function xoyobox_forgotPassword3() {
    window.location.href = "kingsoft://xoyobox_registerPhonePage/";
}

function loginAfterVerify() {
    window.location.href = "kingsoft://loginAfterVerify";
}

function sendVerifyEmail() {
    window.location.href = "kingsoft://sendVerifyEmail";
}


function setDisplayLanguageBar(display) {
    if (display) {
        document.getElementById('languageBar').style.display = 'run-in';
    } else {
        document.getElementById('languageBar').style.display = 'none';
    }
}

function setDisplayRegisterPhoneBtn(display) {
    if (display) {
        document.getElementById('registerPhoneBtn').style.display = 'inline';
    } else {
        document.getElementById('registerPhoneBtn').style.display = 'none';
    }
}

function setDisplayAgreement(enable){
    if (enable == true){
        document.getElementById('divAgreement').style.display = 'inline-block';
    } else {
        document.getElementById('divAgreement').style.display = 'none';
    }
}

//设置账号密码
function setLoginInputAccount(text){
    document.getElementById('account').value = text;
}

function setLoginInputPassword(text) {
    document.getElementById('pwd').value = text;
}

//--新增的国内版的js方法-----
var count = 60;
var text = "s";
var counter;
var reSendMsgText = "Get it again";
function setCountdown(s, title, reSendText){
    count = s;
    text = title;
    reSendMsgText = reSendText;
    document.getElementById("resend").style.pointerEvents = 'none';
    counter = setInterval(timer, 1000);
}

function timer()
{
    count=count-1;
    if (count <= 0)
    {
        clearInterval(counter);
        document.getElementById("resend").style.pointerEvents = 'auto';
        if (document.getElementById('resend').tagName == 'INPUT'){
            document.getElementById('resend').value = reSendMsgText;
        }else{
            document.getElementById("resend").innerHTML = reSendMsgText;
        }
        
        unlockTimer();
        return;
    }
    
    if (document.getElementById('resend').tagName == 'INPUT'){
        document.getElementById('resend').value = count + text;
    } else {
        document.getElementById("resend").innerHTML = count + text;
    }
    
}

function unlockTimer(){
    window.location.href = "kingsoft://unlockTimer/";
}

function loadUrlCss(){
    type = window.location.hash;
    type = type.replace("#","");
    if (type != null)
        loadCSS('../css/'+type+'.css');
}

window.onload = loadUrlCss;


//--新增的海外版的js方法-----

function delAccountList(text){
    window.location.href = "kingsoft://delAccountList/?account=" + text;
}

function clickAccountLoist(text){
    window.location.href = "kingsoft://clickAccountList/?account=" + text;
}

/** get方法 **/
var ACCOUNTLIST = [];
function setAccountList(){
    var $ArrayList  = [];
    for(var i in arguments){
        if((i*1) || (i*1) == 0){
            $ArrayList.push(arguments[i].toLowerCase());
        };
    }
    /** mock 数据 ,实际删去 **/
    //$ArrayList = ['1licanbluesea@kingsoft.com','2licanbluesea@kingsoft.com','3licanbluesea@kingsoft.com'];
    /** mock 数据 ,实际删去 **/
    var _html = [];
    $ArrayList.forEach(function(i,n,a){
                       _html.push('<li data-val="'+ i +'"><span >x</span><b>'+ i +'</b></li>');
                       ACCOUNTLIST.push(i);
                       });
    if (_html.length){
        document.getElementById('account-list').children[0].innerHTML = _html.join('');
    }else{
        document.getElementById('account-list').style.display = 'none';
    }
    
    init();
}
function completeSelect(e){
    var _val = e.value,
    _array = []
    ;
    _array = ACCOUNTLIST.map(function(e){
                             return e.toLowerCase();
                             }).filter(function(e){
                                       return e.indexOf(_val.toLowerCase()) != -1;
                                       });
    var _html = [];
    _array.forEach(function(i,n,a){
                   _html.push('<li data-val="'+ i +'"><span >x</span><b>'+ i +'</b></li>');
                   });
    document.getElementById('account-list').children[0].innerHTML = '';
    if (_html.length){
        document.getElementById('account-list').children[0].innerHTML = _html.join('');
    }else{
        document.getElementById('account-list').style.display = 'none';
        
    }
    init();
}

function init(){
    var acountInputDom = document.getElementById('account');
    var accountListDom = document.getElementById('account-list');
    
    var inputClick = function(e){
        if(!ACCOUNTLIST.length){return false}
        accountListDom.style.display='block';
        e.stopPropagation();
    }
    acountInputDom.removeEventListener('click',inputClick,false)
    acountInputDom.addEventListener('click',inputClick,false);
    var _bDoms = accountListDom.getElementsByTagName('b');
    var _span = accountListDom.getElementsByTagName('span');
    var _nameClick = function(){
        var _params = this.parentNode.getAttribute('data-val');
        clickAccountLoist(_params);
    }
    var _delClick = function(e){
        var _params = this.parentNode.getAttribute('data-val');
        this.parentNode.parentNode.removeChild(this.parentNode);
        e.stopPropagation();
        ACCOUNTLIST.forEach(function(i,n,a){
                            if (i==_params)
                            ACCOUNTLIST.splice(n,1);
                            });
        delAccountList(_params);
    }
    for(var i in _bDoms){
        if((i*1) || (i*1) == 0){
            _bDoms[i].ontouchend = _nameClick;
//            _bDoms[i].removeEventListener('click',_nameClick,false);
//            _bDoms[i].addEventListener('click',_nameClick,false);
        }
    }
    for(var i in _span){
        if((i*1) || (i*1) == 0){
            _span[i].ontouchend = _delClick;
//            _span[i].removeEventListener('click',_delClick,false);
//            _span[i].addEventListener('click',_delClick,false);
        }
    }
    var _clearList = function(){
        document.getElementById('account-list').style.display='none';
    }
    document.body.ontouchend = _clearList;
//    document.body.removeEventListener('click',_clearList,false);
//    document.body.addEventListener('click',_clearList,false);
}

var count = 60;
var text = "s";
var counter;
var reSendMsgText = "Get it again";
function setCountdown(s, title, reSendText){
    count = s;
    text = title;
    reSendMsgText = reSendText;
    document.getElementById("resend").style.pointerEvents = 'none';
    counter = setInterval(timer, 1000);
}

function timer()
{
    count=count-1;
    if (count <= 0)
    {
        clearInterval(counter);
        document.getElementById("resend").style.pointerEvents = 'auto';
        document.getElementById("resend").innerHTML = reSendMsgText;
        unlockTimer();
        return;
    }
    
    document.getElementById("resend").innerHTML = count + text;
}

function unlockTimer(){
    window.location.href = "kingsoft://unlockTimer/";
}


document.onkeydown = function(event) {
    var target, code, tag;
    if (!event) {
        event = window.event; //针对ie浏览器
        target = event.srcElement;
        code = event.keyCode;
        if (code == 13) {
            tag = target.tagName;
            if (tag == "TEXTAREA") { return true; }
            else { return false; }
        }
    }
    else {
        target = event.target; //针对遵循w3c标准的浏览器，如Firefox
        code = event.keyCode;
        if (code == 13) {
            tag = target.tagName;
            if (tag == "INPUT") { return false; }
            else { return true; }
        }
    }
};



