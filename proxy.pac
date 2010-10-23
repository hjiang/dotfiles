function FindProxyForURL(url, host) {
  // Blocked sites.
  var npdoms = [".google.com",
                ".bbc.com",
                ".bbc.co.uk",
                ".wikipedia.org",
                ".blogspot.com",
                ".faqts.com",
                ".bbcworldnews.com",
                ".posterous.com",
                ".mail-archive.com"];

  for (var i = 0; i < npdoms.length; i++) {
    if (dnsDomainIs(host, npdoms[i])){
      return "PROXY localhost:3128";
    }
  }
  return "DIRECT";
}
