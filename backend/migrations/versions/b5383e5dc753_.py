"""empty message

Revision ID: b5383e5dc753
Revises: a66e454c5940
Create Date: 2025-02-22 13:50:17.935107

"""
from alembic import op
import sqlalchemy as sa
from datetime import datetime

# revision identifiers, used by Alembic.
revision = 'b5383e5dc753'
down_revision = 'a66e454c5940'
branch_labels = None
depends_on = None

def upgrade():
    # Сначала обновляем существующие NULL значения текущей датой
    op.execute("UPDATE \"user\" SET created_at = CURRENT_TIMESTAMP WHERE created_at IS NULL")
    # Затем устанавливаем NOT NULL
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.alter_column('created_at',
                              existing_type=sa.DateTime(),
                              nullable=False)

def downgrade():
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.alter_column('created_at',
                              existing_type=sa.DateTime(),
                              nullable=True)
    # ### end Alembic commands ###
