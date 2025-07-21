local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KeyframeSequence = require(ReplicatedStorage.KeyframeSequence)
local base91 = require(ReplicatedStorage.Packages.base91)
local crunchyroll = require(ReplicatedStorage.Packages.crunchyroll)
local squash = require(ReplicatedStorage.Packages.squash)

local rig = crunchyroll.create_rig({
	name = "Root",
	c0 = CFrame.fromMatrix(
		Vector3.new(0, 0, -0),
		Vector3.new(1, -6.123234262925839e-17, -0),
		Vector3.new(6.123234262925839e-17, 1, -0),
		Vector3.new(0, 0, 1)
	),
	c1 = CFrame.identity,
	children = {
		{
			name = "ThirdPersonCamera",
			c0 = CFrame.fromMatrix(
				Vector3.new(-140.4998321533203, 148.5956573486328, -0.0000013963126548333094),
				Vector3.new(1.2167964413833943e-08, -1, -0),
				Vector3.new(1, 1.2167964413833943e-08, -0),
				Vector3.new(0, 0, 1)
			),
			c1 = CFrame.identity,
			children = {},
		},
		{
			name = "IKFootRoot",
			c0 = CFrame.fromMatrix(
				Vector3.new(0, 0, -0),
				Vector3.new(1, 0, -0),
				Vector3.new(0, 1, -0),
				Vector3.new(0, 0, 1)
			),
			c1 = CFrame.identity,
			children = {
				{
					name = "IKLeftFoot",
					c0 = CFrame.fromMatrix(
						Vector3.new(-1.692246675491333, 12.216023445129395, -10.933955192565918),
						Vector3.new(0.9925460815429688, -0.12187014520168304, -0.000005301417786540696),
						Vector3.new(0.000005311524546414148, -2.4193695935537107e-07, 1),
						Vector3.new(-0.12187014520168304, -0.9925460815429688, 4.0718271065998124e-07)
					),
					c1 = CFrame.identity,
					children = {},
				},
				{
					name = "IKRightFoot",
					c0 = CFrame.fromMatrix(
						Vector3.new(-1.6923893690109253, 12.21601390838623, 10.933987617492676),
						Vector3.new(-0.9925460815429688, 0.1218700185418129, -0.000005897095434193034),
						Vector3.new(-0.000005825631433253875, 9.427054123989365e-07, 1),
						Vector3.new(0.1218700185418129, 0.9925460815429688, -2.25708731704799e-07)
					),
					c1 = CFrame.identity,
					children = {},
				},
			},
		},
		{
			name = "IKHandRoot",
			c0 = CFrame.fromMatrix(
				Vector3.new(0, 0, -0),
				Vector3.new(1, 0, -0),
				Vector3.new(0, 1, -0),
				Vector3.new(0, 0, 1)
			),
			c1 = CFrame.identity,
			children = {
				{
					name = "IKHandGun",
					c0 = CFrame.fromMatrix(
						Vector3.new(5.147718906402588, 57.45627212524414, 47.70417785644531),
						Vector3.new(-0.008114331401884556, -0.42335695028305054, -0.9059266448020935),
						Vector3.new(0.9599202871322632, 0.25051942467689514, -0.12567049264907837),
						Vector3.new(0.2801556885242462, -0.870637059211731, 0.40435612201690674)
					),
					c1 = CFrame.identity,
					children = {
						{
							name = "IKLeftHand",
							c0 = CFrame.fromMatrix(
								Vector3.new(86.43287658691406, 11.99005126953125, -38.57883834838867),
								Vector3.new(0.6414062976837158, 0.22770076990127563, -0.7326324582099915),
								Vector3.new(0.2277010679244995, -0.9684126377105713, -0.10163268446922302),
								Vector3.new(-0.7326323390007019, -0.10163334757089615, -0.6729936599731445)
							),
							c1 = CFrame.identity,
							children = {},
						},
						{
							name = "IKRightHand",
							c0 = CFrame.fromMatrix(
								Vector3.new(-0, 0, -0),
								Vector3.new(1, 2.2351743567128324e-08, -5.551115123125783e-17),
								Vector3.new(-2.2351743567128324e-08, 1, -5.551115123125783e-17),
								Vector3.new(5.551115123125783e-17, 5.551115123125783e-17, 1)
							),
							c1 = CFrame.identity,
							children = {},
						},
					},
				},
			},
		},
		{
			name = "LowerTorso",
			c0 = CFrame.fromMatrix(
				Vector3.new(-9.350172547328839e-08, 65.95650482177734, -1.1068115824894309e-13),
				Vector3.new(1, 2.1981177295016252e-11, 0.000004200249804853229),
				Vector3.new(-0.000004200249804853229, 0.000005205331945035141, 1),
				Vector3.new(1.174818841384942e-13, -1, 0.000005205331945035141)
			),
			c1 = CFrame.identity,
			children = {
				{
					name = "UpperTorso01",
					c0 = CFrame.fromMatrix(
						Vector3.new(0.000051189723308198154, 0.000025695688236737624, -12.187240600585938),
						Vector3.new(0.9999998807907104, 1.974668484283626e-10, -0.000516159925609827),
						Vector3.new(1.9124906103229478e-09, 1, 0.000004087797151441919),
						Vector3.new(0.000516159925609827, -0.0000040877976061892696, 0.9999998807907104)
					),
					c1 = CFrame.identity,
					children = {
						{
							name = "UpperTorso02",
							c0 = CFrame.fromMatrix(
								Vector3.new(-2.228343343180228e-10, -7.172595850590824e-13, -13.212663650512695),
								Vector3.new(0.9957351684570312, 0.00011594965326366946, -0.09225782006978989),
								Vector3.new(-0.00011634527618298307, 1, 0.0000010901106861638254),
								Vector3.new(0.09225782006978989, 0.000009648299965192564, 0.9957351684570312)
							),
							c1 = CFrame.identity,
							children = {
								{
									name = "Neck",
									c0 = CFrame.fromMatrix(
										Vector3.new(
											-1.6757769571995595e-07,
											-1.105242286580932e-11,
											-31.339345932006836
										),
										Vector3.new(0.9804974794387817, -0.000167045189300552, 0.19653156399726868),
										Vector3.new(0.00016724436136428267, 1, 0.00001558275835122913),
										Vector3.new(-0.19653156399726868, 0.000017589942217455246, 0.9804974794387817)
									),
									c1 = CFrame.identity,
									children = {
										{
											name = "Head",
											c0 = CFrame.fromMatrix(
												Vector3.new(
													-8.441022600891301e-07,
													1.1044226514225763e-12,
													-9.943029403686523
												),
												Vector3.new(1, -1.56375266153237e-22, 1.3877787807814457e-17),
												Vector3.new(1.56375266153237e-22, 1, 3.2822727644753916e-22),
												Vector3.new(-1.3877787807814457e-17, -3.2822727644753916e-22, 1)
											),
											c1 = CFrame.identity,
											children = {
												{
													name = "FirstPersonCamera",
													c0 = CFrame.fromMatrix(
														Vector3.new(
															19.98295783996582,
															0.0008136083488352597,
															-18.90750503540039
														),
														Vector3.new(
															0.9999707937240601,
															0.00004759461444336921,
															-0.007639619987457991
														),
														Vector3.new(-0.00004755915506393649, 1, 0.000004823215022042859),
														Vector3.new(
															0.007639620453119278,
															-0.000004459740466700168,
															0.9999707937240601
														)
													),
													c1 = CFrame.identity,
													children = {},
												},
											},
										},
									},
								},
								{
									name = "LeftClavicle",
									c0 = CFrame.fromMatrix(
										Vector3.new(-2.615576982498169, -6.2553205490112305, -30.016517639160156),
										Vector3.new(0.9861371517181396, -0.00012351686018519104, 0.1659322828054428),
										Vector3.new(0.1652173101902008, -0.09200342744588852, -0.9819565415382385),
										Vector3.new(0.01538762729614973, 0.9957587122917175, -0.09070758521556854)
									),
									c1 = CFrame.identity,
									children = {
										{
											name = "LeftUpperArm",
											c0 = CFrame.fromMatrix(
												Vector3.new(
													0.00035470910370349884,
													-0.004762076772749424,
													-12.4384126663208
												),
												Vector3.new(
													0.9940603375434875,
													0.10365622490644455,
													0.033157821744680405
												),
												Vector3.new(
													-0.02363765425980091,
													0.5030431747436523,
													-0.8639379739761353
												),
												Vector3.new(
													-0.10623236000537872,
													0.8580226898193359,
													0.5025054812431335
												)
											),
											c1 = CFrame.identity,
											children = {
												{
													name = "LeftLowerArm",
													c0 = CFrame.fromMatrix(
														Vector3.new(
															0.00004070565410074778,
															-0.0000035686377941601677,
															-37.52362060546875
														),
														Vector3.new(
															0.96396404504776,
															0.11343944817781448,
															0.24063430726528168
														),
														Vector3.new(
															-0.1107528805732727,
															0.99354088306427,
															-0.024705270305275917
														),
														Vector3.new(
															-0.2418825626373291,
															-0.0028359508141875267,
															0.9703013896942139
														)
													),
													c1 = CFrame.identity,
													children = {
														{
															name = "LeftHand",
															c0 = CFrame.fromMatrix(
																Vector3.new(
																	-0.00007766066119074821,
																	0.000001236736920873227,
																	-32.64720153808594
																),
																Vector3.new(
																	0.11444175243377686,
																	0.993428647518158,
																	-0.001601157826371491
																),
																Vector3.new(
																	-0.993429958820343,
																	0.11444173753261566,
																	-0.0001023750301101245
																),
																Vector3.new(
																	0.00008153699309332296,
																	0.0016023541102185845,
																	0.9999986886978149
																)
															),
															c1 = CFrame.identity,
															children = {
																{
																	name = "LeftItem",
																	c0 = CFrame.fromMatrix(
																		Vector3.new(
																			-5.770195007324219,
																			0.39785391092300415,
																			-12.032301902770996
																		),
																		Vector3.new(
																			1.209901370202715e-07,
																			2.906520251144684e-07,
																			-1
																		),
																		Vector3.new(
																			-1.729154490703877e-07,
																			-1,
																			-2.9065205353617785e-07
																		),
																		Vector3.new(
																			-1,
																			1.7291549170295184e-07,
																			-1.2099009438770736e-07
																		)
																	),
																	c1 = CFrame.identity,
																	children = {},
																},
															},
														},
													},
												},
											},
										},
									},
								},
								{
									name = "RightClavicle",
									c0 = CFrame.fromMatrix(
										Vector3.new(-2.6140403747558594, 6.256667137145996, -30.01641273498535),
										Vector3.new(-0.9861371517181396, 0.00012069244985468686, -0.16593235731124878),
										Vector3.new(-0.16524018347263336, -0.09196099638938904, 0.9819566607475281),
										Vector3.new(-0.015140790492296219, 0.9957625865936279, 0.09070609509944916)
									),
									c1 = CFrame.identity,
									children = {
										{
											name = "RightUpperArm",
											c0 = CFrame.fromMatrix(
												Vector3.new(
													-0.00035687576746568084,
													0.005090448539704084,
													12.438426971435547
												),
												Vector3.new(0.9940615296363831, 0.10364066064357758, 0.0331704281270504),
												Vector3.new(
													-0.023617122322320938,
													0.5030298233032227,
													-0.8639463186264038
												),
												Vector3.new(
													-0.10622567683458328,
													0.8580324053764343,
													0.5024902820587158
												)
											),
											c1 = CFrame.identity,
											children = {
												{
													name = "RightLowerArm",
													c0 = CFrame.fromMatrix(
														Vector3.new(
															0.000017779471818357706,
															0.000038825040974188596,
															37.52362823486328
														),
														Vector3.new(
															0.9639626741409302,
															0.11344016343355179,
															0.24063946306705475
														),
														Vector3.new(
															-0.11075342446565628,
															0.9935407638549805,
															-0.02470611222088337
														),
														Vector3.new(
															-0.24188777804374695,
															-0.0028358749113976955,
															0.9703000783920288
														)
													),
													c1 = CFrame.identity,
													children = {
														{
															name = "RightHand",
															c0 = CFrame.fromMatrix(
																Vector3.new(
																	0.0000023421710011461983,
																	0.00005348362901713699,
																	32.647220611572266
																),
																Vector3.new(
																	0.11441291123628616,
																	0.9934319853782654,
																	-0.0015994751593098044
																),
																Vector3.new(
																	-0.9934332966804504,
																	0.11441289633512497,
																	-0.00009957778820535168
																),
																Vector3.new(
																	0.0000840768261696212,
																	0.0016003648051992059,
																	0.9999986886978149
																)
															),
															c1 = CFrame.identity,
															children = {
																{
																	name = "RightItem",
																	c0 = CFrame.fromMatrix(
																		Vector3.new(
																			5.770242691040039,
																			-0.39756181836128235,
																			12.031827926635742
																		),
																		Vector3.new(
																			4.1164207686961163e-07,
																			-4.6733907765883487e-07,
																			1
																		),
																		Vector3.new(
																			8.596300204999352e-08,
																			1,
																			4.6733904923712544e-07
																		),
																		Vector3.new(
																			-1,
																			8.596281020345486e-08,
																			4.116421337130305e-07
																		)
																	),
																	c1 = CFrame.identity,
																	children = {},
																},
															},
														},
													},
												},
											},
										},
									},
								},
							},
						},
					},
				},
				{
					name = "LeftUpperLeg",
					c0 = CFrame.fromMatrix(
						Vector3.new(-0.00004490875289775431, -10.011444091796875, -0.00006769832543795928),
						Vector3.new(0.9991784691810608, 0.0012253066524863243, -0.040508028119802475),
						Vector3.new(-0.0005307919927872717, 0.9998527765274048, 0.017151422798633575),
						Vector3.new(0.04052307829260826, -0.01711583137512207, 0.9990320205688477)
					),
					c1 = CFrame.identity,
					children = {
						{
							name = "LeftLowerLeg",
							c0 = CFrame.fromMatrix(
								Vector3.new(0.00002723640136537142, -0.000028593882234417833, 28.614032745361328),
								Vector3.new(0.9882560968399048, -9.55924850387646e-09, 0.1528066098690033),
								Vector3.new(4.8254999995833714e-08, 1, -2.495248736522626e-07),
								Vector3.new(-0.1528066098690033, 2.539681531743554e-07, 0.9882560968399048)
							),
							c1 = CFrame.identity,
							children = {
								{
									name = "LeftFoot",
									c0 = CFrame.fromMatrix(
										Vector3.new(
											-0.000024791193936835043,
											-0.000001377828652948665,
											25.319007873535156
										),
										Vector3.new(0.9999557137489319, 0.00155385653488338, 0.00928240455687046),
										Vector3.new(-0.0013949846616014838, 0.9998528361320496, -0.017097411677241325),
										Vector3.new(-0.00930760521441698, 0.017083706334233284, 0.9998107552528381)
									),
									c1 = CFrame.identity,
									children = {},
								},
							},
						},
					},
				},
				{
					name = "RightUpperLeg",
					c0 = CFrame.fromMatrix(
						Vector3.new(0.000044381617044564337, 10.011460304260254, 0.00005243962004897185),
						Vector3.new(-0.9991784691810608, 0.001232028123922646, 0.04050779715180397),
						Vector3.new(0.0005379215581342578, 0.9998529553413391, -0.017141571268439293),
						Vector3.new(-0.04052295908331871, -0.017105698585510254, -0.999032199382782)
					),
					c1 = CFrame.identity,
					children = {
						{
							name = "RightLowerLeg",
							c0 = CFrame.fromMatrix(
								Vector3.new(0.00007725809700787067, 0.000002441662218188867, -28.61403465270996),
								Vector3.new(0.988255500793457, 5.52437143142015e-07, 0.15281058847904205),
								Vector3.new(-6.020073328727449e-07, 1, 2.781213765956636e-07),
								Vector3.new(-0.15281058847904205, -3.668480701435328e-07, 0.988255500793457)
							),
							c1 = CFrame.identity,
							children = {
								{
									name = "RightFoot",
									c0 = CFrame.fromMatrix(
										Vector3.new(
											-0.00004988978980691172,
											0.000004501720468397252,
											-25.318986892700195
										),
										Vector3.new(0.9999557733535767, 0.0015537351137027144, 0.009278182871639729),
										Vector3.new(-0.001394931459799409, 0.9998528361320496, -0.017097830772399902),
										Vector3.new(-0.009303383529186249, 0.017084132879972458, 0.9998107552528381)
									),
									c1 = CFrame.identity,
									children = {},
								},
							},
						},
					},
				},
			},
		},
	},
})

local animData = base91.decodeBuffer(buffer.fromstring(ReplicatedStorage.Generated.Animations.test.Value))
local cursor = squash.frombuffer(animData)
local kfs = KeyframeSequence.serializer.des(cursor)

local crunchyrollAnim = crunchyroll.load_keyframe_sequence(kfs)
crunchyroll.solve_animation(rig, {
	[crunchyrollAnim] = {
		stop_fade_time = 0, -- 0.25 seconds
		start_fade_time = 0,

		weight = 1, -- Supports blending!
		priority = 1, -- Supports numerical priorities!

		alpha = 0.5, -- Halfway through the animation
	},
}, CFrame.identity)

wait(3)
local character = (script.Parent :: any) :: Model
local skeleton = character:WaitForChild("Skeleton")
local bone = (skeleton:FindFirstChild("LeftUpperArm", true) :: any) :: Bone
-- bone.CFrame = rig.result_coordinate_frames["LeftUpperArm"]
print(((skeleton:FindFirstChild("LeftUpperArm", true) :: any) :: Bone).CFrame)
print(CFrame.fromMatrix(
												Vector3.new(
													0.00035470910370349884,
													-0.004762076772749424,
													-12.4384126663208
												),
												Vector3.new(
													0.9940603375434875,
													0.10365622490644455,
													0.033157821744680405
												),
												Vector3.new(
													-0.02363765425980091,
													0.5030431747436523,
													-0.8639379739761353
												),
												Vector3.new(
													-0.10623236000537872,
													0.8580226898193359,
													0.5025054812431335
												)
											))
