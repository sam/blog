config.reloader.enable!
config.assets.compile = true

Harbor.serve_public_files! config.root + 'public'

config.cache = org.infinispan.manager.DefaultCacheManager.new.get_cache