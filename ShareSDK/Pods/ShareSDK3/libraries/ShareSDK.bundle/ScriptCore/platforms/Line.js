var $pluginID = "com.mob.sharesdk.Line";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([1-9a-zA-Z]|1\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('d y={"z":"covert_url"};6 8(a){7.L=a;7.e={"v":2,"w":2};7._currentUser=2}8.9.a=6(){f 7.L};8.9.p=6(){f"8"};8.9.cacheDomain=6(){f"SSDK-Platform-"+7.a()};8.9.I=6(){5(7.e["w"]!=2&&7.e["w"][y.z]!=2){f 7.e["w"][y.z]}j 5(7.e["v"]!=2&&7.e["v"][y.z]!=2){f 7.e["v"][y.z]}f $1.4.I()};8.9.localAppInfo=6(D){5(M.N==0){f 7.e["v"]}j{7.e["v"]=D}};8.9.serverAppInfo=6(D){5(M.N==0){f 7.e["w"]}j{7.e["w"]=D}};8.9.saveConfig=6(){};8.9.isSupportAuth=6(){f false};8.9.authorize=6(E,settings){d b={"k":$1.4.l.A,"m":"平台［"+7.p()+"］不支持授权功能!"};$1.native.ssdk_authStateChanged(E,$1.4.g.n,b)};8.9.cancelAuthorize=6(3){};8.9.getUserInfo=6(query,3){d b={"k":$1.4.l.A,"m":"平台［"+7.p()+"］不支持获取用户信息功能!"};5(3!=2){3($1.4.g.n,b)}};8.9.addFriend=6(E,user,3){d b={"k":$1.4.l.A,"m":"平台["+7.p()+"]不支持添加好友方法!"};5(3!=2){3($1.4.g.n,b)}};8.9.getFriends=6(cursor,size,3){d b={"k":$1.4.l.A,"m":"平台["+7.p()+"]不支持获取好友列表方法!"};5(3!=2){3($1.4.g.n,b)}};8.9.callApi=6(B,method,params,3){d b={"k":$1.4.l.A,"m":"平台［"+7.p()+"］不支持调用API功能!"};5(3!=2){3($1.4.g.n,b)}};8.9.createUserByRawData=6(rawData){f 2};8.9.share=6(E,o,3){d q=2;d s=2;d b=2;d t=7;d F=o!=2?o["@F"]:2;d u={"@F":F};d a=$1.4.G(7.a(),o,"a");5(a==2){a=$1.4.x.O}5(a==$1.4.x.O){a=7.P(o)}$1.C.isPluginRegisted("com.1.sharesdk.connector.Q",6(c){5(c.h){$1.C.canOpenURL("Q://",6(c){5(c.h){switch(a){R $1.4.x.S:q=$1.4.G(t.a(),o,"q");t.T([q],6(c){q=c.h[0];$1.C.ssdk_lineShareText($1.utils.urlEncode(q),6(c){d i=c.h;5(c.H==$1.4.g.U){i={};i["V"]=c.h;i["q"]=q}5(3!=2){3(c.H,i,2,u)}})});J;R $1.4.x.W:d r=$1.4.G(t.a(),o,"r");5(X.9.Y.Z(r)===\'[10 11]\'){s=r[0]}5(s!=2){t.12(s,6(imageUrl){$1.C.ssdk_lineShareImage(s,6(c){d i=c.h;5(c.H==$1.4.g.U){i={};i["V"]=c.h;i["r"]=[s]}5(3!=2){3(c.H,i,2,u)}})})}j{b={"k":$1.4.l.13,"m":"分享参数s不能为空!"};5(3!=2){3($1.4.g.n,b,2,u)}}J;default:b={"k":$1.4.l.UnsupportContentType,"m":"不支持的分享类型["+a+"]"};5(3!=2){3($1.4.g.n,b,2,u)}J}}j{b={"k":$1.4.l.NotYetInstallClient,"m":"分享平台［"+t.p()+"］尚未安装客户端，不支持分享!"};5(3!=2){3($1.4.g.n,b,2,u)}}})}j{b={"k":$1.4.l.13,"m":"平台["+t.p()+"]需要依靠14.15进行分享，请先导入14.15后再试!"};5(3!=2){3($1.4.g.n,b,2,u)}}})};8.9.12=6(B,3){5(!/^(file\\:\\/)?\\//.test(B)){$1.C.downloadFile(B,6(c){5(c.h!=2){5(3!=2){3(c.h)}}j{5(3!=2){3(2)}}})}j{5(3!=2){3(B)}}};8.9.P=6(o){d a=$1.4.x.S;d r=$1.4.G(7.a(),o,"r");5(X.9.Y.Z(r)===\'[10 11]\'){a=$1.4.x.W}f a};8.9.T=6(K,3){5(7.I()){$1.4.convertUrl(7.a(),2,K,3)}j{5(3){3({"h":K})}}};$1.4.registerPlatformClass($1.4.platformType.8,8);',[],68,'|mob|null|callback|shareSDK|if|function|this|Line|prototype|type|error|data|var|_appInfo|return|responseState|result|resultData|else|error_code|errorCode|error_message|Fail|parameters|name|text|images|image|self|userData|local|server|contentType|LineInfoKeys|ConvertUrl|UnsupportFeature|url|ext|value|sessionId|flags|getShareParam|state|convertUrlEnabled|break|contents|_type|arguments|length|Auto|_getShareType|line|case|Text|_convertUrl|Success|raw_data|Image|Object|toString|apply|object|Array|_getImagePath|APIRequestFail|ShareSDKConnector|framework'.split('|'),0,{}))