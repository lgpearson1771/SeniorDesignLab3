class AddEmailAndVotesleftToInvitees < ActiveRecord::Migration
  def change
    add_column :invitees, :email, :string
    add_column :invitees, :votes_left, :integer
    add_reference :invitees, :poll, index: true
  end
end
