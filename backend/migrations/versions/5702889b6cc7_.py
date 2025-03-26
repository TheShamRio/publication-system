"""empty message

Revision ID: 5702889b6cc7
Revises: 56ca64638927
Create Date: 2025-03-25 23:20:00.100183
"""
from alembic import op
import sqlalchemy as sa

revision = '5702889b6cc7'
down_revision = '56ca64638927'
branch_labels = None
depends_on = None

def upgrade():
    op.execute("DELETE FROM plan_entry")
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.drop_column('expectedCount')
    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.add_column(sa.Column('planned_count', sa.Integer(), nullable=False))
        batch_op.alter_column('type',
               existing_type=sa.VARCHAR(length=50),
               nullable=False)
        batch_op.drop_constraint('plan_entry_publication_id_fkey', type_='foreignkey')
        batch_op.drop_column('isPostApproval')
        batch_op.drop_column('title')
        batch_op.drop_column('publication_id')
        batch_op.drop_column('status')

def downgrade():
    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.add_column(sa.Column('status', sa.VARCHAR(length=50), autoincrement=False, nullable=False))
        batch_op.add_column(sa.Column('publication_id', sa.INTEGER(), autoincrement=False, nullable=True))
        batch_op.add_column(sa.Column('title', sa.VARCHAR(length=200), autoincrement=False, nullable=True))
        batch_op.add_column(sa.Column('isPostApproval', sa.BOOLEAN(), server_default=sa.text('false'), autoincrement=False, nullable=False))
        batch_op.create_foreign_key('plan_entry_publication_id_fkey', 'publication', ['publication_id'], ['id'])
        batch_op.alter_column('type',
               existing_type=sa.VARCHAR(length=50),
               nullable=True)
        batch_op.drop_column('planned_count')
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.add_column(sa.Column('expectedCount', sa.INTEGER(), autoincrement=False, nullable=False))