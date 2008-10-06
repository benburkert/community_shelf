namespace :merb do
  namespace :cache do
    desc "clear the caches"
    task :clear do
      FileUtils.rm_rf(Merb.root / :tmp / :actions)
      FileUtils.rm_rf(Merb.root / :tmp / :fragments)
      FileUtils.rm_rf(Merb.root / :tmp / :pages)
    end
  end
end