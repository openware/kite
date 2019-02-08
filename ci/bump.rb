require 'rubygems/version'
require 'net/http'
require 'json'
require 'uri'

#
# Returns bot's username in GitHub.
#
# @return [String]
def bot_username
  ENV.fetch('BOT_USERNAME', 'kite-bot')
end

#
# Returns bot's displayed name in commits.
#
# @return [String]
def bot_name
  ENV.fetch('BOT_NAME', 'Kite Bot')
end

#
# Returns bot's displayed email in commits.
#
# @return [String]
def bot_email
  ENV.fetch('BOT_EMAIL', 'kite-bot@rubykube.io')
end

#
# Returns GitHub repository slug in form of :user|:organization/:repository.
#
# @return [String]
def repository_slug
  ENV.fetch('REPOSITORY_SLUG', 'rubykube/kite')
end

#
# Increments the version which is in stage of support (version-specific branches only),
# and publishes it on the GitHub.
#
# The method expects branch name in form of 'X-Y-stable', like '2-0-stable'.
# It tags the current Git commit to the next patch number version, and pushes it to Git repository.
#
# @param name [String]
#   Branch name.
def bump_from_version_specific_branch(name)
  # This helps to ensure branch does exist.
  branch = version_specific_branches.find { |b| b[:name] == name }
  return unless branch

  # Find latest version for the branch (compare by major and minor).
  # We use find here since versions are sorted in descending order.
  latest_version = versions.reverse.find { |v| v.segments[0...2] == branch[:version].segments }

  # Increment patch version number, tag, and push.
  if latest_version
    candidate_version = Gem::Version.new(latest_version.segments.dup.tap { |s| s[2] += 1 }.join('.'))
  else
    candidate_version = "#{branch[:version].segments.join('.')}.0"
  end

  tag_n_push(candidate_version.to_s) unless versions.include?(candidate_version)
end

#
# Configures Git user name & email,
# creates Git tag
#
# @param tag [String]
def tag_n_push(tag)
  [
    %( git config --global user.email "#{bot_email}" ),
    %( git config --global user.name "#{bot_name}" ),
    %( git remote add authenticated-origin https://#{bot_username}:#{ENV.fetch('GITHUB_API_KEY')}@github.com/#{repository_slug} ),
    %( git tag #{tag} -a -m 'Automatically generated tag' ),
    %( git push authenticated-origin #{tag} )
  ].each do |command|
    command.strip!
    unless Kernel.system(command)
      # Prevent GitHub API key from being published.
      command.gsub!(ENV['GITHUB_API_KEY'], '(secret)')
      raise %(Command "#{command}" exited with status #{$?.exitstatus || '(unavailable)'}.)
    end
  end
end

#
# Loads all tags, and returns them in ascending order.
#
# @return [Array<Gem::Version>]
def versions
  @versions ||= github_api_authenticated_get("/repos/#{repository_slug}/tags").map do |x|
    Gem::Version.new(x.fetch('name'))
  end.sort
end

#
# Returns hash with all tagged commits as keys (SHA-1) and versions as values.
#
# @return [Hash]
#   Key is commit's SHA-1 hash, value is instance of Gem::Version.
def tagged_commits_mapping
  @commits ||= github_api_authenticated_get("/repos/#{repository_slug}/tags").each_with_object({}) do |x, memo|
    memo[x.fetch('commit').fetch('sha')] = Gem::Version.new(x.fetch('name'))
  end
end

#
# Loads all branches, selects only version-specific, and returns them.
#
# @return [Array<Hash>]
#   Array of hashes each containing 'name' & 'version' keys.
def version_specific_branches
  @branches ||= github_api_authenticated_get("/repos/#{repository_slug}/branches").map do |x|
    if x.fetch('name') =~ /\A(\d)-(\d)-\w+\z/
      { name: x['name'], version: Gem::Version.new($1 + '.' + $2) }
    end
  end.compact
end

#
# Performs call to GitHub API and returns the response. Raises in case of non-200 status.
#
# @param path [String]
#   Request path.
# @return [Hash]
def github_api_authenticated_get(path)
  http         = Net::HTTP.new('api.github.com', 443)
  http.use_ssl = true
  response     = http.get path, 'Authorization' => %[token #{ENV.fetch('GITHUB_API_KEY')}]
  if response.code.to_i == 200
    JSON.load(response.body)
  else
    raise StandardError, %[HTTP #{response.code}: "#{response.body}".]
  end
end

#
# Returns true if version has exactly 3 version segments (major, minor, patch), and all are integers.
#
# @param version [Gem::Version]
# @return [true, false]
def generic_semver?(version)
  version.segments.count == 3 && version.segments.all? { |segment| segment.match?(/\A[0-9]+\z/) }
end

bump_from_version_specific_branch(ENV.fetch('DRONE_BRANCH'))
