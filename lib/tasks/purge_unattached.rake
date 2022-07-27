namespace :custom do
  desc "Purges unattached Active Storage blobs. Run regularly."
  task purge_unattached: :environment do
    ActiveStorage::Blob.unattached.each("active_storage_blobs.created_at <= ?", 2.days.ago).find_each(&:purge_later)
  end
end
