class CreateJoinTableBlocksInvitees < ActiveRecord::Migration
  def change
    create_join_table :blocks, :invitees do |t|
      t.index [:block_id, :invitee_id]
      t.index [:invitee_id, :block_id]
    end
  end
end
