user = User.create(telegram_id: 42)

tag1 = Tag.create(content: 'star wars')
tag2 = Tag.create(content: 'cinematic')
tag3 = Tag.create(content: 'march')
tag4 = Tag.create(content: 'bury')

sound1 = Sound.create(title: 'Imperial march')
sound1.add_tag(tag1)
sound1.add_tag(tag2)
sound1.add_tag(tag3)
sound1.save_changes

sound2 = Sound.create(title: 'Burial march')
sound2.add_tag(tag3)
sound2.add_tag(tag4)
sound2.save_changes

sound3 = Sound.create(title: 'Nooooo')
sound3.add_tag(tag1)
sound3.add_tag(tag2)
sound3.save_changes

Choice.create(user: user, sound: sound1, query: 'imperial')
Choice.create(user: user, sound: sound1, query: 'star wars')
Choice.create(user: user, sound: sound1, query: 'star wars')
Choice.create(user: user, sound: sound1, query: 'star wars')
Choice.create(user: user, sound: sound1, query: 'march')
Choice.create(user: user, sound: sound1, query: 'march')
Choice.create(user: user, sound: sound1, query: 'march')
Choice.create(user: user, sound: sound1, query: 'march')
Choice.create(user: user, sound: sound1, query: 'march')
Choice.create(user: user, sound: sound2, query: 'bury')
Choice.create(user: user, sound: sound2, query: 'march')
Choice.create(user: user, sound: sound2, query: 'march')
Choice.create(user: user, sound: sound2, query: 'march')
Choice.create(user: user, sound: sound2, query: 'cinematic')
Choice.create(user: user, sound: sound2, query: 'cinematic')
Choice.create(user: user, sound: sound2, query: 'cinematic')
Choice.create(user: user, sound: sound3, query: 'star wars')
