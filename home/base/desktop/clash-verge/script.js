// Define main function (script entry)

function main(config, profileName) {
  // Netease Mumu Player 12 Ad-Blocker
  [ "DOMAIN,shence-api.mumu.163.com,REJECT"
  , "DOMAIN,nemu.fp.ps.netease.com,REJECT"
  , "DOMAIN,mumu.nie.netease.com,REJECT"
  , "DOMAIN,hubble.netease.com,REJECT"
  , "DOMAIN,store-api.mumu.163.com,REJECT"
  ].map(rule=>config['rules'].splice(1, 0, rule))


  // Github API Rate Limits
  config['proxy-groups'].push({
    name:'GitHub API',
    type: 'url-test',
    url: 'https://api.github.com/',
    "expected-status": 200,
    interval: 10*1000,
    proxies: config['proxies']
      .map((proxy)=>proxy.name)
  })
  config['rules'].splice(1, 0, "DOMAIN,api.github.com,GitHub API")

  // Auto Proxy
  config['proxy-groups'].push({
    name:'ext.AutoProxies',
    type: 'url-test',
    url: 'http://www.gstatic.com/generate_204',
    interval: 86400,
    proxies: config['proxies']
      .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
      .map((proxy)=>proxy.name)
  })
  config['proxy-groups'][0].proxies.splice(0, 0, "ext.AutoProxies")

  // Japanese Blacklist Website
  config['proxy-groups'].push({
    name:'No Asia Proxies',
    type: 'url-test',
    url: 'http://www.gstatic.com/generate_204',
    interval: 86400,
    proxies: config['proxies']
      .filter((proxy)=>!/(^JP)|(日本)|(韩)|(KO?R)/.test(proxy.name))
      .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
      .map((proxy)=>proxy.name)
  })
  config['rules'].splice(1, 0, "DOMAIN-SUFFIX,hxcy.top,No Asia Proxies")

  return config;
}
