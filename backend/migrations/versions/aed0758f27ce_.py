"""empty message

Revision ID: aed0758f27ce
Revises: b5383e5dc753
Create Date: 2025-02-22 22:38:42.287079

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'aed0758f27ce'
down_revision = 'b5383e5dc753'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('achievement', schema=None) as batch_op:
        batch_op.alter_column('user_id',
               existing_type=sa.INTEGER(),
               nullable=False)
        batch_op.alter_column('date_earned',
               existing_type=postgresql.TIMESTAMP(),
               nullable=False)

    with op.batch_alter_table('publication', schema=None) as batch_op:
        batch_op.alter_column('updated_at',
               existing_type=postgresql.TIMESTAMP(),
               nullable=False)

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('publication', schema=None) as batch_op:
        batch_op.alter_column('updated_at',
               existing_type=postgresql.TIMESTAMP(),
               nullable=True)

    with op.batch_alter_table('achievement', schema=None) as batch_op:
        batch_op.alter_column('date_earned',
               existing_type=postgresql.TIMESTAMP(),
               nullable=True)
        batch_op.alter_column('user_id',
               existing_type=sa.INTEGER(),
               nullable=True)

    # ### end Alembic commands ###
