"""Add status to Plan model
Revision ID: d1da80bdc0ec
Revises: 2b51823fa60b
Create Date: <дата создания>
"""

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'd1da80bdc0ec'
down_revision = '2b51823fa60b'
branch_labels = None
depends_on = None

def upgrade():
    # Шаг 1: Добавляем столбец status без NOT NULL
    op.add_column('plan', sa.Column('status', sa.String(length=20), nullable=True))
    
    # Шаг 2: Заполняем существующие строки значением по умолчанию 'draft'
    op.execute("UPDATE plan SET status = 'draft' WHERE status IS NULL")
    
    # Шаг 3: Устанавливаем NOT NULL после заполнения
    op.alter_column('plan', 'status', nullable=False)

def downgrade():
    # Удаляем столбец status при откате
    op.drop_column('plan', 'status')