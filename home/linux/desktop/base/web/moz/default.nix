{
  pkgs,
  myutils,
  ...
}: let
  patchIcon = pkgs.lib.concatStringsSep "\n" (
    builtins.map (den: ''
      TARGET_${den}=$out/lib/firefox/browser/chrome/icons/default/default${den}.png
      [ -f "$TARGET_${den}" ] && rm "$TARGET_${den}"
      convert ${./kitsune.png} -resize ${den}x${den}  "$TARGET_${den}"
    '') [
      "16"
      "32"
      "48"
      "64"
      "128"
    ]
  );

  firefox-kitsune = (pkgs.wrapFirefox) (pkgs.firefox-unwrapped.overrideAttrs (super: {
    nativeBuildInputs =
      super.nativeBuildInputs
      ++ [
        pkgs.imagemagick
      ];
    postInstall = "${super.postInstall}\n${patchIcon}";
  })) {};
in {
  xdg.mimeApps.defaultApplications =
    (myutils.attrs.listToAttrs [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/chrome"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ] (_: ["firefox.desktop"]))
    // (myutils.attrs.listToAttrs [
      "application/x-extension-rss=userapp"
      "application/rss+xml"
      "x-scheme-handler/feed"
      "x-scheme-handler/mid"
      "message/rfc822"
      "x-scheme-handler/mailto"
    ] (_: ["thunderbird.deskto"]));

  programs = {
    firefox = {
      enable = true;
      package = firefox-kitsune;
      languagePacks = [
        "zh-CN"
        "en-US"
        "jp"
      ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        PictureInPicture.Value = true;
        DisablePocket = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "never";
        SearchBar = "unified";
        ExtensionSettings =
          {
            # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
            "zotero@chnm.gmu.edu" = {
              install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
              installation_mode = "force_installed";
            };
          }
          // (with builtins; let
            extension = shortId: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          in
            listToAttrs [
              # GO about:debugging#/runtime/this-firefox to get Extension ID
              # (extension "aria2_integration" "{e2488817-3d73-4013-850d-b66c5e42d505}")
              (extension "auto_tab_discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
              (exntesion "behind-the-overlay-revival" "{c0e1baea-b4cb-4b62-97f0-278392ff8c37}")
              (extension "bewlybewly" "addon@bewlybewly.com")
              (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
              (extension "bilisponsorblock" "{f10c197e-c2a4-43b6-a982-7e186f7c63d9}") #B站空降助手
              (extension "carrot" "{f0eeb71a-e5d6-48e6-a818-568a6bef1bc0}")
              (extension "codeforces-practice-tracker" "{26b28813-67de-4a83-9fbe-eaf008f68732}")
              (extension "competitive-companion" "{74e326aa-c645-4495-9287-b6febc5565a7}")
              (extension "cookie_quick_manager" "{60f82f00-9ad5-4de5-b31c-b16a47c51558}")
              (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
              (extension "header_editor" "headereditor-amo@addon.firefoxcn.net")
              (extension "history-autodelete" "{7e79d10d-9667-4d38-838d-471281c568c3}")
              (extension "i_dont_care_about_cookies" "jid1-KKzOGWgsW3Ao4Q@jetpack")
              (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
              (extension "markdown_here" "markdown-here-webext@adam.pritchard")
              (extension "nighttab" "{47bf427e-c83d-457d-9b3d-3db4118574bd}")
              (extension "web-clipper-obsidian" "clipper@obsidian.md")
              (extension "pakkujs" "{646d57f4-d65c-4f0d-8e80-5800b92cfdaa}")
              (extension "phtotshow" "{c23d8eea-4e71-4573-a245-4c97f8e1a1e0}")
              (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
              (extension "rsspreview" "{7799824a-30fe-4c67-8b3e-7094ea203c94}")
              (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
              (extension "single-file" "{531906d3-e22f-4a6c-a102-8057b88a1a63}")
              (extension "soundfixer" "soundfixer@unrelenting.technology")
              # surfingkeys broken on codeforces.com, use vimium-ff instead
              # (extension "surfingkeys_ff" "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}")
              (extension "tab-auto-refresh" "{7fee47a1-8299-4576-90bf-5fd88d756926}")
              (extension "tampermonkey" "firefox@tampermonkey.net")
              (extension "textarea_cache" "textarea-cache-lite@wildsky.cc")
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "unpaywall" "{f209234a-76f0-4735-9920-eb62507a54cd}")
              (extension "user_agent_string_switcher" "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}")
              (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
              (extension "wappalyzer" "wappalyzer@crunchlabz.com")
              (extension "wxif" "{8b3ee44a-0805-4c2c-acef-15aab34fbd20}")
            ]);
      };

      profiles.default = {
        id = 0;
        isDefault = true;
        containersForce = true;
        containers = {
          Default = {
            color = "blue";
            icon = "fingerprint";
            id = 1;
          };
          NSFW = {
            color = "purple";
            icon = "chill";
            id = 2;
          };
        };
        userChrome = ''
          ${builtins.readFile ./userChrome.notitlebar.css}
          ${builtins.readFile ./userChrome.pengufox.css}
        '';
        userContent = ''
          ${builtins.readFile ./userContent.pengufox.css}
        '';

        settings = {
          "services.sync.username" = "1302485739@qq.com";

          "browser.startup.homepage" = "moz-extension://7ff2085c-0b4f-4bc4-a1b0-dcac266cb90f/index.html";
          "browser.search.defaultenginename" = "Google";
          "browser.search.order.1" = "Google";
          "browser.startup.page" = 3; # Resume previous session on startup
          "browser.download.useDownloadDir" = false; # Ask where to save stuff
          "browser.aboutConfig.showWarning" = false; # I sometimes know what I'm doing
          "privacy.clearOnShutdown.history" = false; # We want to save history on exit
          "browser.ctrlTab.sortByRecentlyUsed" = false; # (default) Who wants that?
          "browser.tabs.unloadOnLowMemory" = true;
          "intl.accept_languages" = "zh-cn,en-us,jp";
          "signon.autofillForms" = false;
          "browser.translations.panelShown" = false;
          "devtools.chrome.enabled" = true; # Allow executing JS in the dev console 
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Allow userCrome.css
          # Why the fuck can my search window make bell sounds
          "accessibility.typeaheadfind.enablesound" = false;


          # Privacy
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "browser.send_pings" = false; # (default) Don't respect <a ping=...>

          # This allows firefox devs changing options for a small amount of users to test out stuff.
          # Not with me please ...
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
          "device.sensors.enabled" = false; # This isn't a phone
          "geo.enabled" = false; # Disable geolocation alltogether

          # ESNI is deprecated ECH is recommended
          "network.dns.echconfig.enabled" = true;

          # Disable telemetry for privacy reasons
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.enabled" = false; # enforced by nixos
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;
          "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false; # (default)

          # Disable some useless stuff
          "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
          "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
          "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
          # "identity.fxaccounts.enabled" = false; # disable firefox login
          # "identity.fxaccounts.toolbar.enabled" = false;
          # "identity.fxaccounts.pairing.enabled" = false;
          # "identity.fxaccounts.commands.enabled" = false;
          "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
          "browser.uitour.enabled" = false; # no tutorial please
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # disable annoying web features
          "dom.battery.enabled" = false; # you don't need to see my battery...
          "dom.private-attribution.submission.enabled" = false; # No PPA for me pls
          "dom.push.enabled" = false; # no notifications, really...
          "dom.push.connection.enabled" = false;

          "extensions.webcompat.enable_shims" = true;
          "sidebar.position_start" = false;
          "findbar.highlightAll" = true;
          "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[\"edit-controls\",\"zoom-controls\",\"screenshot-button\",\"firefox-view-button\",\"characterencoding-button\",\"developer-button\",\"profiler-button\"],\"unified-extensions-area\":[\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"headereditor-amo_addon_firefoxcn_net-browser-action\",\"textarea-cache-lite_wildsky_cc-browser-action\",\"_7fee47a1-8299-4576-90bf-5fd88d756926_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"_3c078156-979c-498b-8990-85f7987dd929_-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_646d57f4-d65c-4f0d-8e80-5800b92cfdaa_-browser-action\",\"_5efceaa7-f3a2-4e59-a54b-85319448e305_-browser-action\",\"_f0eeb71a-e5d6-48e6-a818-568a6bef1bc0_-browser-action\",\"wappalyzer_crunchlabz_com-browser-action\",\"soundfixer_unrelenting_technology-browser-action\",\"markdown-here-webext_adam_pritchard-browser-action\",\"_e2488817-3d73-4013-850d-b66c5e42d505_-browser-action\",\"_c23d8eea-4e71-4573-a245-4c97f8e1a1e0_-browser-action\",\"treestyletab_piro_sakura_ne_jp-browser-action\",\"_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action\",\"_c3c10168-4186-445c-9c5b-63f12b8e2c87_-browser-action\",\"_26b28813-67de-4a83-9fbe-eaf008f68732_-browser-action\",\"_7e79d10d-9667-4d38-838d-471281c568c3_-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"_c0e1baea-b4cb-4b62-97f0-278392ff8c37_-browser-action\",\"jid1-bofifl9vbdl2zq_jetpack-browser-action\",\"_b5371a03-0432-4f66-951f-07bd6c4465a9_-browser-action\",\"_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action\",\"_60f82f00-9ad5-4de5-b31c-b16a47c51558_-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"jid1-zadieub7xozojw_jetpack-browser-action\",\"_f5197d2b-302b-4ffe-b73c-b397dc22a5b7_-browser-action\",\"_9c267187-2207-4f94-8b7d-aa2fd06b8587_-browser-action\",\"_7a73dc4b-1b38-40e7-ac56-7d356dd4af34_-browser-action\",\"onepagefavorites3_onepagefavorites_com-browser-action\",\"_f10c197e-c2a4-43b6-a982-7e186f7c63d9_-browser-action\"],\"nav-bar\":[\"sync-button\",\"customizableui-special-spring11\",\"back-button\",\"forward-button\",\"stop-reload-button\",\"zotero_chnm_gmu_edu-browser-action\",\"urlbar-container\",\"_74e326aa-c645-4495-9287-b6febc5565a7_-browser-action\",\"customizableui-special-spring10\",\"downloads-button\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_a8332c60-5b6d-41ee-bfc8-e9bb331d34ad_-browser-action\",\"clipper_obsidian_md-browser-action\",\"_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action\",\"unified-extensions-button\",\"sidebar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"_74e326aa-c645-4495-9287-b6febc5565a7_-browser-action\",\"_646d57f4-d65c-4f0d-8e80-5800b92cfdaa_-browser-action\",\"_5efceaa7-f3a2-4e59-a54b-85319448e305_-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"_f0eeb71a-e5d6-48e6-a818-568a6bef1bc0_-browser-action\",\"wappalyzer_crunchlabz_com-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"soundfixer_unrelenting_technology-browser-action\",\"markdown-here-webext_adam_pritchard-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_e2488817-3d73-4013-850d-b66c5e42d505_-browser-action\",\"_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action\",\"_c23d8eea-4e71-4573-a245-4c97f8e1a1e0_-browser-action\",\"treestyletab_piro_sakura_ne_jp-browser-action\",\"simple-tab-groups_drive4ik-browser-action\",\"_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action\",\"_a8332c60-5b6d-41ee-bfc8-e9bb331d34ad_-browser-action\",\"_c3c10168-4186-445c-9c5b-63f12b8e2c87_-browser-action\",\"smartproxy_salarcode_com-browser-action\",\"_26b28813-67de-4a83-9fbe-eaf008f68732_-browser-action\",\"_7fee47a1-8299-4576-90bf-5fd88d756926_-browser-action\",\"_7e79d10d-9667-4d38-838d-471281c568c3_-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"zotero_chnm_gmu_edu-browser-action\",\"_c0e1baea-b4cb-4b62-97f0-278392ff8c37_-browser-action\",\"headereditor-amo_addon_firefoxcn_net-browser-action\",\"jid0-hynmqxa9zqgfjadreri4n2ahksi_jetpack-browser-action\",\"textarea-cache-lite_wildsky_cc-browser-action\",\"jid1-bofifl9vbdl2zq_jetpack-browser-action\",\"_b5371a03-0432-4f66-951f-07bd6c4465a9_-browser-action\",\"_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action\",\"_60f82f00-9ad5-4de5-b31c-b16a47c51558_-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"cf-pop_lilydjwg_me-browser-action\",\"jid1-zadieub7xozojw_jetpack-browser-action\",\"profiler-button\",\"_f5197d2b-302b-4ffe-b73c-b397dc22a5b7_-browser-action\",\"_3c078156-979c-498b-8990-85f7987dd929_-browser-action\",\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"_9c267187-2207-4f94-8b7d-aa2fd06b8587_-browser-action\",\"_7a73dc4b-1b38-40e7-ac56-7d356dd4af34_-browser-action\",\"_f10c197e-c2a4-43b6-a982-7e186f7c63d9_-browser-action\",\"onepagefavorites3_onepagefavorites_com-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"clipper_obsidian_md-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\",\"vertical-tabs\",\"widget-overflow-fixed-list\"],\"currentVersion\":20,\"newElementCount\":18}";
        };
        search = {
          force = true;
          default = "Google";
          engines = {
            "Google".metaData.alias = "@g";
            "Bing".metaData.alias = "@bing";
            "DuckDuckGo".metaData.alias = "@ddg";
            "Wikipedia".metaData.alias = "@wiki";
            "Baidu" = {
              urls = [
                {
                  template = "https://www.baidu.com/s";
                  params = [
                    {
                      name = "wd";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://www.baidu.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@bd"];
            };
            "BiliBili" = {
              urls = [
                {
                  template = "https://search.bilibili.com/all";
                  params = [
                    {
                      name = "keyword";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@bili"];
              updateInterval = 24 * 60 * 60 * 1000;
              iconUpdateURL = "https://i0.hdslb.com/bfs/static/jinkela/long/images/favicon.ico";
            };
            "Youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@ytb"];
              updateInterval = 24 * 60 * 60 * 1000;
              iconUpdateURL = "https://www.youtube.com/s/desktop/ef8ce500/img/favicon.ico";
            };
            "Moegirl Wiki" = {
              urls = [
                {
                  template = "https://zh.moegirl.org.cn/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@moe"];
              updateInterval = 24 * 60 * 60 * 1000;
              iconUpdateURL = "https://img.moegirl.org.cn/favicon.ico";
            };
            "GitHub" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "type";
                      value = "repositories";
                    }
                  ];
                }
              ];
              definedAliases = ["@gh"];
              updateInterval = 24 * 60 * 60 * 1000;
              iconUpdateURL = "https://github.githubassets.com/favicons/favicon.svg";
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nix"];
            };
          };
        };
      };
    };
  };

  home.packages = [
    pkgs.ungoogled-chromium # used for debuging on chromium kernel based browsers
    pkgs.thunderbird
    pkgs.tor-browser
  ];
}
