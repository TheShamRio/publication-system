from alembic import op
import sqlalchemy as sa

revision = '5cb8466e3b2b'
down_revision = '8fa25025665f'
branch_labels = None
depends_on = None

def upgrade():
    # Добавляем столбец с server_default, чтобы заполнить существующие строки
    op.add_column('plan_entry', sa.Column('isPostApproval', sa.Boolean(), server_default=sa.false(), nullable=False))

def downgrade():
    op.drop_column('plan_entry', 'isPostApproval')
    