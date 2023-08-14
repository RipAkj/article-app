class AddArticleToRevision < ActiveRecord::Migration[7.0]
  def change
    add_column :revisions, :article_id, :integer
    add_column :revisions, :title, :string
    add_column :revisions, :description, :string
    add_column :revisions, :topic, :string
  end
end
