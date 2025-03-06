
from alembic import op
import sqlalchemy as sa

revision = 'd0c950a3873b'
down_revision = 'd1da80bdc0ec'
branch_labels = None
depends_on = None

def upgrade():
    # Step 1: Add the user_id column to the plan table
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.add_column(sa.Column('user_id', sa.Integer(), nullable=True))

    # Step 2: Update user_id for existing rows
    op.execute("UPDATE plan SET user_id = (SELECT id FROM \"user\" LIMIT 1) WHERE user_id IS NULL")

    # Step 3: Make user_id non-nullable and add foreign key
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.alter_column('user_id', nullable=False)
        batch_op.create_foreign_key('fk_plan_user_id', 'user', ['user_id'], ['id'])

    # Similar steps for the plan_entry table (if applicable)
    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.add_column(sa.Column('status', sa.String(length=50), nullable=True))

    op.execute("UPDATE plan_entry SET status = 'draft' WHERE status IS NULL")

    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.alter_column('status', nullable=False)
        batch_op.create_foreign_key('fk_plan_entry_plan_id', 'plan', ['plan_id'], ['id'])
def downgrade():
    # For plan_entry table
    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.drop_constraint('fk_plan_entry_plan_id', type_='foreignkey')
        batch_op.drop_column('status')

    # For plan table
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.drop_constraint('fk_plan_user_id', type_='foreignkey')
        batch_op.drop_column('user_id')