"""empty message

Revision ID: bc7fd4311d19
Revises: d0c950a3873b
Create Date: 2025-03-06 14:26:25.708812

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'bc7fd4311d19'
down_revision = 'd0c950a3873b'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.add_column(sa.Column('return_comment', sa.Text(), nullable=True))

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('plan', schema=None) as batch_op:
        batch_op.drop_column('return_comment')

    # ### end Alembic commands ###
