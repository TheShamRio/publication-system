"""authors
    - authorid
    - name
    - surname
    - third_name
    - email
    - phone number
    - ? userId
"""

"""publication author
    - authorid
    - publicationId
"""

"""publication metadata
    Id - UUID
    UserID - who inserted to the db(foreign key)
    Title - tile of publication
    DateCreated - date of publication
    PublicationFormId (foreign key)
    DateUpdated - date of change
    StatusId - foreign key
    FileURI - URI where the publication is stored
    JournalConferenceName
    DOI
    ISSN
    ISBN
    Quartile
    VOLUME
    Number - номер выпуска публикации
    Pages - location in the journal
    PrintedSheetsVolume - объем в печатных листах
    Classification code
    publication type alias id( foreign key)
    Тираж
    departmentId (foreign key)
    publisherId (foreign key)
"""

"""note
    - id
    - publication id
    - text
"""

"""department
    - id
    - name
"""

"""publisher
    - ID
    - Title
    - Location
"""

"""publication_index(vak, rinc, scopus, wos, none)
    id
    title
"""


"""
publication status type
    id - UUID
    titile - string(черновик, требуется проверка, отправлено на доработку, опубликована)
"""


"""publication type
    - id
    - name
"""

"""display name
    - id
    - name
    - publication type id (foreign key)
"""

"""publication form
    - id
    - title
"""