"""empty message

Revision ID: 25d723a9dca1
Revises: 5702889b6cc7
Create Date: 2025-03-25 23:46:14.336336
"""
from alembic import op
import sqlalchemy as sa

revision = '25d723a9dca1'
down_revision = '5702889b6cc7'
branch_labels = None
depends_on = None

def upgrade():
    # Удаляем таблицу plan_entry_publications
    op.drop_table('plan_entry_publications')
    
    # Добавляем столбец expectedCount с server_default=0 и сразу NOT NULL
    op.add_column('plan', sa.Column('expectedCount', sa.Integer(), server_default='0', nullable=False))

    # Обновляем таблицу plan_entry с использованием batch_alter_table
    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.add_column(sa.Column('title', sa.String(length=200), nullable=True))
        batch_op.add_column(sa.Column('publication_id', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('status', sa.String(length=50), nullable=False, server_default='pending'))
        batch_op.add_column(sa.Column('isPostApproval', sa.Boolean(), nullable=False, server_default=sa.false()))
        batch_op.alter_column('type',
               existing_type=sa.VARCHAR(length=50),
               nullable=True)
        batch_op.create_foreign_key(None, 'publication', ['publication_id'], ['id'])
        batch_op.drop_column('planned_count')

def downgrade():
    # Откатываем изменения в plan_entry
    with op.batch_alter_table('plan_entry', schema=None) as batch_op:
        batch_op.add_column(sa.Column('planned_count', sa.INTEGER(), autoincrement=False, nullable=False))
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.alter_column('type',
               existing_type=sa.VARCHAR(length=50),
               nullable=False)
        batch_op.drop_column('isPostApproval')
        batch_op.drop_column('status')
        batch_op.drop_column('publication_id')
        batch_op.drop_column('title')

    # Откатываем изменения в plan
    op.drop_column('plan', 'expectedCount')

    # Воссоздаем таблицу plan_entry_publications
    op.create_table('plan_entry_publications',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('plan_entry_id', sa.INTEGER(), autoincrement=False, nullable=False),
        sa.Column('publication_id', sa.INTEGER(), autoincrement=False, nullable=False),
        sa.ForeignKeyConstraint(['plan_entry_id'], ['plan_entry.id'], name='plan_entry_publications_plan_entry_id_fkey'),
        sa.ForeignKeyConstraint(['publication_id'], ['publication.id'], name='plan_entry_publications_publication_id_fkey'),
        sa.PrimaryKeyConstraint('id', name='plan_entry_publications_pkey')
    )