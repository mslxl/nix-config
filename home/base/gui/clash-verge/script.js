// Define main function (script entry)

function main(config, profileName) {
  // Netease Mumu Player 12 Ad-Blocker
  [ "DOMAIN,shence-api.mumu.163.com"
  , "DOMAIN,nemu.fp.ps.netease.com"
  , "DOMAIN,mumu.nie.netease.com"
  , "DOMAIN,hubble.netease.com"
  , "DOMAIN,store-api.mumu.163.com"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},REJECT`));

  [ "DOMAIN,wakatime.mslxl.com"
  , "DOMAIN,rss.mslxl.com"
  , "DOMAIN-SUFFIX,steamserver.net" // Steam Resource Download Server
  , "DOMAIN-SUFFIX,sdufe.edu.cn"
  , "DOMAIN-SUFFIX,2k.com"
  , "DOMAIN-SUFFIX,folo.is"
  , "DOMAIN-SUFFIX,follow.is"
  , "DOMAIN-SUFFIX,msftconnecttest.com"
  , "DOMAIN-SUFFIX,steamdb.info"
  //, "DOMAIN-SUFFIX,gtnewhorizons.com"
  , "PROCESS-NAME,qbittorrent.exe"
  , "PROCESS-NAME,CivilizationVI_DX12.exe"
  , "PROCESS-NAME,CivilizationVI_DX11.exe"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},DIRECT`));

  // Github API Rate Limits
  config['proxy-groups'].push({
    name:'userScript.GitHubAPI',
    type: 'url-test',
    url: 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable',
    "expected-status": 200,
    interval: 10*1000,
    proxies: config['proxies']
      .map((proxy)=>proxy.name)
  });

  [ "DOMAIN,api.github.com"
  , "DOMAIN-SUFFIX,github.com"
  , "DOMAIN-SUFFIX,githubusercontent.com"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},userScript.GitHubAPI`));

  // Auto Proxy
  config['proxy-groups'].push({
    name:'userScript.AutoProxies',
    type: 'url-test',
    url: 'http://www.gstatic.com/generate_204',
    interval: 86400,
    proxies: config['proxies']
      .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
      .map((proxy)=>proxy.name)
  });
  // Set default proxy for first proxy-groups
  // Usually the first proxy-group is default proxy route
  config['proxy-groups'][0].proxies.splice(0, 0, "userScript.AutoProxies");
  for(let proxy of config['proxy-groups']){
    if(proxy.name === '自动选择'){
      proxy.type = 'select';
      proxy.proxies = ['userScript.AutoProxies']
    }
  }


  
  [ "DOMAIN,calibre-ebook.com"
  , "DOMAIN-SUFFIX,thenewslens.com"
  , "DOMAIN-SUFFIX,catimage.work"
  , "DOMAIN-SUFFIX,steampowered.com"
  , "DOMAIN-SUFFIX,gtnewhorizons.com"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},userScript.AutoProxies`));

  // Japan Blacklist Website
  config['proxy-groups'].push({
    name:'userScript.NoAsiaProxies',
    type: 'url-test',
    url: 'http://www.gstatic.com/generate_204',
    interval: 86400,
    proxies: config['proxies']
      .filter((proxy)=>!/(^JP)|(日本)|(^KO?R)|(韩)|(^HK)|(香港)|(^TW)|(台湾)|(^MAC)|(澳门)/.test(proxy.name))
      .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
      .map((proxy)=>proxy.name)
  });
  
  [ "DOMAIN,steamdb.info"
  , "DOMAIN,hxcy.top"
  , "DOMAIN,galgame.best"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},userScript.NoAsiaProxies`));

  // Japan Website
  config['proxy-groups'].push((()=>{
    const p = {
      name:'userScript.JapanProxies',
      type: 'url-test',
      url: 'http://www.gstatic.com/generate_204',
      interval: 86400,
      proxies: config['proxies']
        .filter((proxy)=>/(^JP)|(日本)/.test(proxy.name))
        .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
        .map((proxy)=>proxy.name)
    };
    if(p.proxies.length == 0){
      p.proxies = ['userScript.AutoProxies'];
    }
    return p;
  })());
  [
    "DOMAIN-SUFFIX,dmm.com"
  , "DOMAIN-SUFFIX,dmm.co.jp"
  , "DOMAIN-SUFFIX,dlsite.com"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},userScript.JapanProxies`));

  // Japan Website
  config['proxy-groups'].push((()=>{
    const p = {
      name:'userScript.USAProxies',
      type: 'url-test',
      url: 'http://www.gstatic.com/generate_204',
      interval: 86400,
      proxies: config['proxies']
        .filter((proxy)=>/(^US)|(美国)/.test(proxy.name))
        .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
        .map((proxy)=>proxy.name)
    };
    if(p.proxies.length == 0){
      p.proxies = ['userScript.AutoProxies'];
    }
    return p;
  })());

  [
    "DOMAIN-SUFFIX,truthsocial.com"
  , "DOMAIN-SUFFIX,donaldjtrump.com"
  , "DOMAIN-SUFFIX,winred.com"
  , "DOMAIN,chatgpt.com"
  , "DOMAIN,chat.openai.com"
  , "DOMAIN-SUFFIX,openai.com",
  , "DOMAIN-SUFFIX,tiktok.com"
  , "DOMAIN-SUFFIX,tiktokcdn-us.com"
  , "DOMAIN-SUFFIX,tiktokcdn.com"
  , "DOMAIN-SUFFIX,tiktokw.us"
  , "DOMAIN-SUFFIX,tiktokv.us"
  , "DOMAIN-SUFFIX,blob.core.windows.net" // GitHub Assets/Release,
  , "DOMAIN-SUFFIX,cursor.com"
  , "DOMAIN-SUFFIX,cursor.sh"
  , "DOMAIN-SUFFIX,gemini.google.com"
  , "DOMAIN-SUFFIX,aistudio.google.com"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},userScript.USAProxies`));

  // Adobe Auth Blocker
  [ "DOMAIN-SUFFIX,adobe.io"
  , "DOMAIN-SUFFIX,adobestats.io"
  ].forEach(rule=>config['rules'].splice(1, 0, `${rule},REJECT`));
  
  return config;
}
