// Define main function (script entry)

function main(config, profileName) {
  // Github API Rate Limits
  config['proxy-groups'].push({
    name:'GitHub API',
    type: 'url-test',
    url: 'https://api.github.com/orgs/spring',
    "expected-status": "200",
    interval: 86400,
    proxies: config['proxies']
      .map((proxy)=>proxy.name)
  })
  config['rules'].splice(1, 0, "DOMAIN,api.github.com,GitHub API")

 
  // Japanese Blacklist Website
  config['proxy-groups'].push({
    name:'No JAP Proxies',
    type: 'url-test',
    url: 'http://www.gstatic.com/generate_204',
    interval: 86400,
    proxies: config['proxies']
      .filter((proxy)=>!/(^JP)|(日本)/.test(proxy.name))
      .filter((proxy)=>!/[(自动选择)(故障转移)(剩余流量)(套餐到期)]/.test(proxy.name))
      .map((proxy)=>proxy.name)
  })
  config['rules'].splice(1, 0, "DOMAIN,hxcy.top,No JAP Proxies")

  return config;
}
