# Toddler Taxonomist 

Toddler Taxonomist is an iPad app designed to entertain young children while helping them learn the names of a lot of different types of organisms. In its first incarnation, all of the organisms are animals, but there are plans to expand to include other Kindoms. I mean, really: what toddlers don't want to learn how to identify fungi by their scientifc names?

Toddler Taxonomist and its source are developed and released by [GameAid](http://www.gameaid.org), a new non-profit initiative in the process of applying for 501(c)3 status. Please visit [http://www.gameaid.org](http://www.gameaid.org) for more information.

Toddler Taxonomist by GameAid is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>. 

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png" /></a>

-------

## General Information

The purpose of Toddler Taxonomist is to entertain 2-4 year old children.

**Toddler Taxonomist is in a prototype stage. The code is disorganized.**

There is a display mode and a difficulty level. With each difficulty level, the application runs through several display modes. First it will show 2 photos, then 4, then 8, then 40, after which it will jump to the next difficulty level and show 2 pictures, etc. When a player misses a question on the first guess, their progress is impeded. When they correctly answer a question, they progress towards the next difficulty level. For most toddlers, they never will notice this. The goal is that it will settle on a difficulty level where they sometimes answer correctly and sometimes don't, in order to present a consistent challenge. 

Most of the heavy lifting of moving between questions is handled by the `BoardLayer` class, in combination with the `AnimalCatalogue`, `Question`, `Tile`, and `Organism` classes. 

-------

### Adding Organisms

There are a number of steps involved in adding organisms to Toddler Taxonomist.

##### Data

First of all, the [database](https://github.com/GameAid/Toddler-Taxonomist/blob/master/Toddler%20Taxonomist/animal_list.xlsx) currently consists of the following fields for each species of organism:

* Common Name
* Specific Name
* Binomial / Trinomial Name
* Kingdom
* Phylum
* Class
* Subclass
* Infraclass
* Superorder
* Order
* Suborder
* Family
* Subfamily
* Genus
* Species (without the genus prefix; it can be generated programmatically)
* Mammal
* Arthropod
* Reptile
* Amphibian
* Endangered (mushy definition, based on the Wikipedia indicators)
* Extinct
* Nocturnal
* image_01 (legacy naming, in case organisms support multiple images in the future)
* image_01_source (needs to include licensing terms for images, but doesn't yet)
* Description
* Wikipedia Link
* generic_name (used to play the sounds for generic names, at easy difficulty levels)
* photo_credit

Note: Excel on the Mac has trouble properly exporting UTF-8 characters, which can lead to garbled strings in the csv file. The best way to properly export the csv file is to load the Excel file into a Google Spreadsheet and to export csv from there.


##### Images

For each organism, to support retina and standard displays, images are needed in the following sizes. Note that I tried to do fewer sizes, but scaling them to fit at run time introduced too much lag and caused memory problems on the iPad 2.

* `1280 x 1280`
* `1024 x 1280`
* `1024 x  640`
* ` 512 x  640`
* ` 256 x  256`

All of the images are in `.jpg` format. To save an image properly, use the `image_01` prefix for the organism, followed by an underscore, then the dimensions with a dash, and the extensions. For example, the lion with the `image_01` prefix of `lion_01` would have these images:

* `lion_01_1280-1280.jpg`
* `lion_01_1024-1280.jpg`
* `lion_01_1024-640.jpg`
* `lion_01_512-640.jpg`
* `lion_01_256-256.jpg`

I tried to automate the generation of these images, but found that it didn't work very well because of the specific framing needed for the different image shapes. Obviously, the generation of some of them can be automated because they are in the same ratio. However, I found that the images sometimes were clearer when different framing was used for the different resolutions, even if they are in the same aspect ratio. 

##### Sounds
Sound files use the `image_01` name or each organism, so they must be saved with the same name or they will not work. When Toddler Taxonomist is running at easy difficulty level, it uses the `generic_name`. For this list, I've substituted the `image_01` names with `imagename` and the `generic_name` values with `generic`.

* `thats_imagename.mp3` ("That's a Katanga Lion!")
* `where_imagename.mp3` ("Where's the Katanga Lion?")
* `thats_generic.mp3` ("That's a Lion.")
* `where_generic.mp3` ("Where's the lion?")
* `thats_sci_imagename.mp3` ("That's Panthera leo bleyenberghi.")
* `where_sci_imagename.mp3`  ("Where's Panthera leo bleyenberghi?")

There are 10 "correct" and 10 "incorrect" sounds, titled from `correct_1.mp3` to `correct_10.mp3` and `incorrect_1.mp3` to `incorrect_10.mp3`.

Additional sounds for informational text have yet to be added.

-------

#### Personal Developer Note

I started and am trying to get [GameAid](http://www.gameaid.org) off the ground. Founding a federally-recognized non-profit corporation is somewhat expensive. While Toddler Taxonomist is a GameAid product, it currently is published through [The Perihelion Group](http://www.theperiheliongroup.com)'s developer account. The Perihelion Group is an LLC through which I do my for-profit work.

My hope is to take proceeds from Toddler Taxonomist and use them to pay for some of the expenses in supporting GameAid. Once GameAid is properly established, The Perihelion Group will no longer sell Toddler Taxonomist and all legal rights to it and copyrights will be donated to GameAid.

If you are reading this and the concept of GameAid interests you, please contact me at `info@gameaid.org` and we can discuss how you might be able to help GameAid, either through providing a service or financial donation. Thank you. -- Clay Heaton (25 April 2013)