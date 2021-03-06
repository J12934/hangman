import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import shuffle from 'lodash/shuffle';
import { KEYBOARD_PRESS, RESET_GAME } from './chromecast-messages'

const isGoogleCast = / CrKey\//.test(navigator.userAgent);

const RANDOM_WORDS = [
  'kayle',
  'vawted',
  'undersexed',
  'pugaree',
  'damfool',
  'lanceted',
  'omening',
  'brigantines',
  'outcrow',
  'millstones',
  'sublimit',
  'electrifier',
  'glidder',
  'redefeat',
  'extemporize',
  'ettercap',
  'fabulize',
  'explicatory',
  'attack',
  'wounding',
  'evasiveness',
  'obviated',
  'outsparkled',
  'whiskey',
  'trachle',
  'deprecate',
  'dolent',
  'wad',
  'tailoress',
  'doubleheaders',
  'prosemen',
  'boater',
  'photolyses',
  'necessarianisms',
  'inappropriateness',
  'edematose',
  'cliquishness',
  'noosphere',
  'mulmull',
  'successionists',
  'puritanize',
  'fadednesses',
  'anagrammer',
  'footle',
  'jimpness',
  'intertill',
  'merl',
  'passepied',
  'possess',
  'alumni',
  'demeritorious',
  'nominates',
  'salicins',
  'superport',
  'accession',
  'undecidednesses',
  'likening',
  'backmarker',
  'adults',
  'rocamboles',
  'corporatizes',
  'cicatrises',
  'encharges',
  'megatonic',
  'teniacide',
  'hyperexcitable',
  'lapidarists',
  'bourd',
  'perimetry',
  'rocailles',
  'diaphorases',
  'ichnology',
  'praelected',
  'supernormalities',
  'firmless',
  'seroons',
  'campanologist',
  'postromantic',
  'serriedly',
  'analyzing',
  'pumiceous',
  'musically',
  'jaghirdars',
  'interpolar',
  'plouky',
  'epithelises',
  'rewakening',
  'nephrectomizing',
  'smarted',
  'hagride',
  'bludgeoned',
  'massaranduba',
  'creaturehood',
  'overconstructed',
  'vezirs',
  'sudsless',
  'presifts',
  'amidmost',
  'sclerotium',
  'dentiform',
  'chain',
  'battleplane',
  'conversos',
  'tophe',
  'fansites',
  'repainting',
  'graciosities',
  'bezant',
  'ergosterols',
  'liths',
  'dewed',
  'lingoes',
  'demilitarizing',
  'scattered',
  'championship',
  'flagellant',
  'keeperless',
  'bisulphites',
  'shortie',
  'postage',
  'biblike',
  'lockpick',
  'bluefishes',
  'razoos',
  'molecularities',
  'prefect',
  'herbariums',
  'lampadephoria',
  'piscinas',
  'thickies',
  'oversoak',
  'karyogram',
  'homeotherms',
  'petulancies',
  'caudices',
  'elaborations',
  'crewels',
  'predetermines',
  'indifference',
  'binominals',
  'camoodis',
  'cheechako',
  'bandshells',
  'crossarm',
  'hackable',
  'accursedness',
  'demutualises',
  'drant',
  'strip',
  'tremulated',
  'enamines',
  'audiogram',
  'damar',
  'punitive',
  'gingall',
  'nikaus',
  'rupture',
  'cytophotometry',
  'reproducer',
  'chlamydia',
  'rapturousnesses',
  'ferventest',
  'dignifiedly',
  'rationalistic',
  'screaks',
  'landsmen',
  'ballons',
  'peculiarizing',
  'erosivenesses',
  'valvulites',
  'veinulets',
  'prores',
  'braunschweigers',
  'mercurous',
  'alabandites',
  'megasporangium',
  'chiromantic',
  'tillicum',
  'intenerating',
  'curpels',
  'chappal',
  'tabularises',
  'sinfulnesses',
  'colourized',
  'upshots',
  'elasticating',
  'pieceworkers',
  'authigenic',
  'shoemakings',
  'stoneboat',
  'genlocks',
  'convertibility',
  'player',
  'overembellished',
  'trawlermen',
  'haji',
  'hispidity',
  'azotes',
  'unhasps',
  'inquere',
  'wolfskin',
  'rollick',
  'coenures',
  'sedulousnesses',
  'aerenchymata',
  'fussbudgets',
  'mankiest',
  'meatier',
  'blueballs',
  'supergenes',
  'fizzling',
  'leavened',
  'furthest',
  'exclamational',
  'lulu',
  'pupating',
  'airfoil',
  'milksopping',
  'hangared',
  'dissidences',
  'tetartohedrally',
  'reinfunding',
  'sandblast',
  'confiscation',
  'stemma',
  'pearlers',
  'cabinmate',
  'endamoeba',
  'dolichuruses',
  'shelfed',
  'forevermore',
  'occlusors',
  'incondensable',
  'radioactivities',
  'necessitate',
  'tune',
  'antiacademics',
  'icebox',
  'chalazas',
  'undrained',
  'outrank',
  'gymnasium',
  'robotics',
  'undervaluation',
  'angosturas',
  'planning',
  'noncandidacies',
  'foulies',
  'burnettized',
  'nymphish',
  'afterguard',
  'lawfulness',
  'ladyfly',
  'florideans',
  'joll',
  'twopences',
  'sulphuring',
  'mistouches',
  'adieux',
  'presented',
  'meritless',
  'handlings',
  'deaner',
  'homologized',
  'schoolteachers',
  'regences',
  'pulture',
  'graybeard',
  'innless',
  'detox',
  'jo',
  'hierodules',
  'jobber',
  'zinciferous',
  'radiologic',
  'stactes',
  'tritheists',
  'vibrate',
  'spiderweb',
  'synthetism',
  'barned',
  'virtually',
  'felicity',
  'hoickses',
  'dybbuks',
  'attention',
  'uncoalesce',
  'bylanes',
  'tiptop',
  'patisserie',
  'relativised',
  'hongiing',
  'alegging',
  'anecdotal',
  'foins',
  'matronliness',
  'pepsines',
  'conventionally',
  'inshipping',
  'suburbanises',
  'browsy',
  'tractilities',
  'diapsid',
  'oxfords',
  'hemitropisms',
  'washups',
  'thyrotropins',
  'pharisaic',
  'lollers',
  'addies',
  'printability',
  'gracefullest',
  'allylic',
  'anilinctus',
  'variometers',
  'definers',
  'justiciarships',
  'unshift',
  'camarillas',
  'pocosin',
  'gramash',
  'reprivatizes',
  'garganey',
  'situated',
  'agate',
  'decerebrized',
  'gynaecium',
  'semiparasitic',
  'vitaminises',
  'theopathic',
  'presternum',
  'countertenors',
  'translations',
  'communal',
  'theophanous',
  'homogenous',
  'technophobic',
  'enounced',
  'triturated',
  'plausibility',
  'wattest',
  'didelphid',
  'skeuomorphs',
  'reillumine',
  'olfacted',
  'lehaims',
  'ungrammatically',
  'diarchy',
  'kaliphates',
  'postponement',
  'ferniest',
  'muscats',
  'distrainees',
  'underlapping',
  'samarskites',
  'wingding',
  'wealthiest',
  'killingly',
  'prezzies',
  'witchy',
  'oncost',
  'tohunga',
  'discounselled',
  'handfeed',
  'engram',
  'acrophobes',
  'unwarily',
  'blindsided',
  'crinoids',
  'leakinesses',
  'empathy',
  'upholstery',
  'lirks',
  'woodlanders',
  'antiferromagnetically',
  'melanitic',
  'forlana',
  'jeering',
  'starve',
  'vitellogenic',
  'fairnesses',
  'orgasmically',
  'intermat',
  'filigreeing',
  'granitizes',
  'argyrites',
  'gemot',
  'bayberries',
  'antiacademics',
  'parsonical',
  'naves',
  'holiday',
  'imboldening',
  'greenhouses',
  'lairing',
  'carburise',
  'albarelli',
  'plumeries',
  'pryingly',
  'skywriter',
  'unredeemed',
  'screwable',
  'phonophobias',
  'oceanologists',
  'muchacho',
  'cervix',
  'slushing',
  'resynthesized',
  'fourths',
  'assertedly',
  'salsilla',
  'skrimshankers',
  'besteads',
  'cameses',
  'irritates',
  'survivers',
  'centiles',
  'minded',
  'suspenders',
  'clavichordist',
  'tindals',
  'compacts',
  'subbureau',
  'dopeynesses',
  'panfish',
  'debentures',
  'contras',
  'fluorotype',
  'handcrafted',
  'shockproof',
  'colpitis',
  'suffix',
  'phototactically',
  'bambino',
  'liquable',
  'escorted',
  'overflies',
  'uplinked',
  'plyometric',
  'humefying',
  'kilobauds',
  'ambience',
  'cocaptained',
  'tommy',
  'inspirits',
  'catnips',
  'ethonone',
  'ignoble',
  'grumphies',
  'jambones',
  'undecided',
  'fishskins',
  'subjectivisms',
  'gliomatosis',
  'wytes',
  'cimar',
  'dogey',
  'crustose',
  'nitwittedness',
  'estaminets',
  'corrugations',
  'nazification',
  'sphaerosiderite',
  'ichthyosaur',
  'bobowler',
  'muscatorium',
  'tucutucu',
  'fortifications',
  'subjectivenesses',
  'champignon',
  'fascinatedly',
  'literality',
  'comprised',
  'duodenectomies',
  'polyhedra',
  'rebellers',
  'monochord',
  'doomed',
  'sulfathiazoles',
  'caners',
  'distillatory',
  'coiffures',
  'digitising',
  'cladogram',
  'nerds',
  'fullish',
  'alkyd',
  'nite',
  'microphysical',
  'thwaite',
  'multinucleated',
  'baserunning',
  'brominisms',
  'alluringly',
  'tired',
  'interosculate',
  'epencephalic',
  'milepost',
  'tripudia',
  'tyrannise',
  'photodecompositions',
  'impropriations',
  'inframaxillary',
  'needs',
  'modius',
  'medicals',
  'speciesism',
  'counterrevolutionaries',
  'xenomanias',
  'begirting',
  'douked',
  'neonatologist',
  'agitas',
  'transplantings',
  'dentaliums',
  'curved',
  'caravanned',
  'ombudsman',
  'pinion',
  'activize',
  'turbidimetrically',
  'duller',
  'blower',
  'tarp',
  'matinees',
  'congenitalness',
  'ultraleftisms',
  'allotetraploidy',
  'shedlike',
  'saltato',
  'referral',
  'stablishes',
  'bigae',
  'tropeolin',
  'uncapturable',
  'kesar',
  'woggles',
  'armlets',
  'uncaused',
  'mariniere',
  'hardstandings',
  'representatively',
  'demurral',
  'scholarliness',
  'wackinesses',
  'vined',
  'ascared',
  'tangie',
  'postpartum',
  'disquisitory',
  'verrel',
  'hexachlorides',
  'alterations',
  'electroplated',
  'ferlies',
  'timpanist',
  'albuminises',
  'gynecic',
  'reattributes',
  'earring',
  'whiteflies',
  'schismatic',
  'knappers',
  'vaporific',
  'crustier',
  'respectablenesses',
  'dermography',
  'isophotes',
  'keffel',
  'hymenophore',
  'orometers',
  'speat',
  'authorises',
  'foraminiferal',
  'wayside',
  'hijackings',
  'tumblebugs',
  'popedoms',
  'cattalo',
  'impotently',
  'condensational',
  'myrmecology',
  'bambinos',
  'adpress',
  'tercels',
  'nonaccidental',
  'amateurism',
  'baddeleyites',
  'halachas',
  'hejab',
  'multicultural',
  'skeens',
  'glimmers',
  'multicounty',
  'wauchted',
  'ottrelites',
  'photoelectrons',
  'vetchling',
  'hearie',
  'slapdashed',
  'powhiris',
  'lateralized',
  'romanizing',
  'sceptically',
  'goiter',
  'ulnaria',
  'spellbind',
  'febricula',
  'rattliest',
  'scowed',
  'quadrisects',
  'nocturias',
  'babied',
  'repopularizes',
  'discriminatory',
  'aureus',
  'counterspell',
  'gestaltism',
  'oppignorating',
  'fondus',
  'bystreet',
  'polygraphies',
  'awlworts',
  'vespiaries',
  'trash',
  'sectionises',
  'ectypographies',
  'mutchkin',
  'unsullied',
  'skriech',
  'beheading',
  'enrange',
  'stackups',
  'outsworn',
  'boisterous',
  'theosophist',
  'mainstreams',
  'terrorists',
  'histologies',
  'camphol',
  'stegosaurs',
  'simmered',
  'geta',
  'zarnec',
  'neutrettos',
  'cuffins',
  'japanizing',
  'foreordination',
  'thyroidectomy',
  'tendonitis',
  'dvandva',
  'devotement',
  'boatlifted',
  'aminopyrines',
  'substantialism',
  'quadriliterals',
  'processer',
  'replantation',
  'profanes',
  'impecuniously',
  'approofs',
  'undervests',
  'bandsters',
  'protrusivenesses',
  'obscurities',
  'finikin',
  'now',
  'nonsugar',
  'corsetiers',
  'ternes',
  'magnetizer',
  'kachahri',
  'mousmes',
  'coachwhip',
  'decarbonations',
  'persuaded',
  'adaptationally',
  'enfeeble',
  'serricorn',
  'polonie',
  'misplans',
  'roentgenizing',
  'hailier',
  'cavatine',
  'omissible',
  'fantastication',
  'animalizes',
  'nosies',
  'nonyl',
  'nudges',
  'quantics',
  'benighting',
  'lying',
  'huss',
  'bootlicked',
  'formiates',
  'ariels',
  'actomyosin',
  'scoop',
  'deediest',
  'leprousness',
  'arrows',
  'underpays',
  'cloudscapes',
  'clogdances',
  'zoiatrias',
  'mother',
  'imitant',
  'delassements',
  'undinted',
  'wingchairs',
  'pheasantry',
  'bale',
  'numbed',
  'loirs',
  'curia',
  'boxiest',
  'crummie',
  'downstage',
  'breenged',
  'panidiomorphic',
  'begunked',
  'vagal',
  'bucketful',
  'epicurean',
  'pathogenicities',
  'tautophonical',
  'alula',
  'detruncate',
  'oscitances',
  'hallucinatory',
  'central',
  'unbraided',
  'experimentally',
  'surfboardings',
  'ornamented',
  'healthy',
  'fluidified',
  'emplaster',
  'cohousings',
  'plyingly',
  'lastingnesses',
  'contumeliously',
  'continentalist',
  'hyperrealists',
  'ribgrass',
  'hithering',
  'educatedness',
  'secularizations',
  'antiburglary',
  'whemmles',
  'dolor',
  'farthingless',
  'dichts',
  'pitters',
  'jirble',
  'henchpersons',
  'seamlessnesses',
  'iodizer',
  'amphoric',
  'valetudinarian',
  'empiecements',
  'legalese',
  'wandoos',
  'jawari',
  'sullennesses',
  'diables',
  'shogging',
  'postilled',
  'plantocracy',
  'antimilitarists',
  'expellent',
  'dismemberments',
  'electroclashes',
  'yealing',
  'snotteries',
  'straightedge',
  'panarthritis',
  'radiating',
  'subtlety',
  'kistfuls',
  'ummed',
  'pyromaniacs',
  'bouviers',
  'oophorectomises',
  'scarphs',
  'thioalcohols',
  'textually',
  'reprographic',
  'spicing',
  'geocarpic',
  'zillions',
  'vainglories',
  'inculcates',
  'pivotally',
  'prosternum',
  'homologating',
  'lowns',
  'asymptotical',
  'morbidities',
  'indolency',
  'mismet',
  'palaeographer',
  'malaxing',
  'diplex',
  'steelworks',
  'inditers',
  'fantod',
  'enters',
  'underblankets',
  'emblazes',
  'bipack',
  'multijugous',
  'mishanters',
  'recommitment',
  'couchee',
  'dauber',
  'polygeneses',
  'airgun',
  'stirps',
  'strapping',
  'foetoscopy',
  'wastelots',
  'lycopods',
  'teacher',
  'azides',
  'demurrage',
  'coverlets',
  'saltcellars',
  'barometrically',
  'vasectomies',
  'dramshops',
  'cryoconite',
  'hypothesise',
  'adminiculates',
  'cyanates',
  'misinformation',
  'adornment',
  'glomerating',
  'uncoupled',
  'mimicked',
  'ou',
  'multifaced',
  'sanely',
  'counterinstance',
  'belonged',
  'sunburn',
  'charging',
  'justiciarships',
  'pushdown',
  'outwishes',
  'byzants',
  'underdeveloping',
  'unenchanted',
  'enjoying',
  'simkin',
  'putlocks',
  'knell',
  'raffs',
  'lipases',
  'unblameably',
  'stereoregular',
  'clour',
  'nonphosphates',
  'penults',
  'yonkers',
  'dada',
  'catechetical',
  'enfeloned',
  'polyconic',
  'antinodes',
  'heterotopy',
  'aquariums',
  'osteoid',
  'steerable',
  'webzines',
  'maillot',
  'showerings',
  'gentilising',
  'scarves',
  'chopine',
  'fartlek',
  'infamy',
  'lysigenic',
  'despotically',
  'asports',
  'unneighboured',
  'circussy',
  'ladyloves',
  'hylozoism',
  'pleomorphy',
  'cores',
  'comarts',
  'pergolas',
  'sealifting',
  'relegation',
  'slunk',
  'overdependent',
  'derision',
  'precedential',
  'silverskins',
  'palaeographical',
  'doff',
  'pectin',
  'controvertible',
  'repryving',
  'measureless',
  'daunered',
  'boomtowns',
  'rhumbatron',
  'slaughtering',
  'inappreciation',
  'pasteurizes',
  'eyeballs',
  'moribundity',
  'omphalic',
  'popsicles',
  'crogs',
  'erythema',
  'topazolite',
  'uncooked',
  'stereographed',
  'peacod',
  'intensification',
  'suppliable',
  'overcontrol',
  'deliberated',
  'oceanologists',
  'masculinises',
  'muxing',
  'recirculating',
  'arbitration',
  'localite',
  'coelenterate',
  'faint',
  'cajun',
  'masquerades',
  'gingerades',
  'choreographic',
  'globalizes',
  'skieyer',
  'premoistening',
  'vicenary',
  'noninterventionist',
  'gemmate',
  'autocrosses',
  'gadling',
  'beflag',
  'dissertator',
  'milden',
  'yachtmen',
  'heldentenors',
  'reradiation',
  'scandias',
  'carnals',
  'pestilence',
  'ureses',
  'victualler',
  'reequipments',
  'daidled',
  'prunts',
  'owrier',
  'gaelicizing',
  'tortuously',
  'misrule',
  'hibernicized',
  'wabblers',
  'respirated',
  'metallurgists',
  'provenders',
  'quinquefoliate',
  'polywaters',
  'regreened',
  'firewood',
  'barrack',
  'carotins',
  'possessions',
  'malleating',
  'bedridden',
  'hryvna',
  'balsa',
  'prequalifying',
  'catenaries',
  'bummel',
  'uriniparous',
  'disjoint',
  'prises',
  'excreta',
  'undersoil',
  'textualism',
  'semiannually',
  'chinwags',
  'soilier',
  'horrider',
  'composedness',
  'reik',
  'swampland',
  'hirudinean',
  'sorghums',
  'shechitas',
];

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: shuffle(RANDOM_WORDS),
});

registerServiceWorker();

if (isGoogleCast) {
	cast.framework.CastReceiverContext.getInstance().setLoggerLevel(cast.framework.LoggerLevel.DEBUG);
    cast.framework.CastReceiverContext.getInstance()
        .addCustomMessageListener('urn:x-cast:mi136-hangman', msg => {
			const { type, payload } = msg.data;

            switch (type) {
				case KEYBOARD_PRESS:
					app.ports.chromecastKeyPress.send(payload.keyCode);
					break;

				case RESET_GAME:
					app.ports.chromecastResetGame.send(null);
					break;
			}
        });
    cast.framework.CastReceiverContext.getInstance().start();
}
