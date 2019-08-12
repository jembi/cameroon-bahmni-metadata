INSERT IGNORE INTO entity_mapping_type
    (name,uuid,entity1_type,entity2_type,date_created)
VALUES
    ('visittype_location','bf9c4e41-4b69-49b4-986d-1aafdb7dcd55','org.openmrs.VisitType','org.openmrs.Location',now());

INSERT IGNORE INTO entity_mapping
    (uuid,entity_mapping_type_id,entity1_uuid,entity2_uuid,date_created)
VALUES
    ('511aafc0-9e54-11e9-a2a3-2a2ae2dbcce4',5,'bc475481-050a-4938-b00a-e8dc6b9b4c01','0efa13f3-4351-4e9c-91fd-1d33a1833028',now()),
    ('511ab27c-9e54-11e9-a2a3-2a2ae2dbcce4',5,'a71de1a2-aa43-496a-a533-13f47fad0129','1144b765-2e6c-47b9-bb2d-e059ad1680a8',now()),
    ('511ab3ee-9e54-11e9-a2a3-2a2ae2dbcce4',5,'b1d913d1-70d8-4d6e-8aa6-e71f8b60a004','ff553570-8eca-4649-9c44-e1b06921796c',now()),
    ('511ab650-9e54-11e9-a2a3-2a2ae2dbcce4',5,'9b5f2493-fa75-44f9-80e4-bb389121ea0d','0d9bf0c2-39f5-489a-a660-927f1ac97b7b',now()),
    ('511ab7cc-9e54-11e9-a2a3-2a2ae2dbcce4',5,'74c0393a-f5dd-4f4d-98bb-cedda584349b','c6e23237-5a0d-438a-9381-ac403d30054f',now()),
    ('511ab916-9e54-11e9-a2a3-2a2ae2dbcce4',5,'f0a00d58-eeb8-4454-a41c-c8c2664313ec','79157d5d-1e45-407d-bf15-ae8dc1674a70',now()),
    ('511abae2-9e54-11e9-a2a3-2a2ae2dbcce4',5,'660e38b5-2599-4ff5-b3fe-5c3fe0a5cd7e','d1757c49-d3eb-4b36-bb2c-1d3faf238b20',now()),
    ('511abc4a-9e54-11e9-a2a3-2a2ae2dbcce4',5,'b7d778bb-53ab-479c-a903-5bf18a62b0f3','4f2e70b3-9b18-4773-994e-c67b31422722',now()),
    ('511abd9e-9e54-11e9-a2a3-2a2ae2dbcce4',5,'9eb68046-b654-4884-b560-d1275caa84a7','8568c575-16fc-4330-a3bb-c0460c15a298',now()),
    ('511abfba-9e54-11e9-a2a3-2a2ae2dbcce4',5,'34cefcc2-0f50-4589-a487-9a68cdf3c11a','31b46228-0cb2-4e33-b8aa-4fcbae016adc',now()),
    ('511ac12c-9e54-11e9-a2a3-2a2ae2dbcce4',5,'dc0c872a-97d5-4731-aa00-ab8dd712e761','ee0644c1-53e1-4c8c-bcd9-2308c608be60',now()),
    ('511ac26c-9e54-11e9-a2a3-2a2ae2dbcce4',5,'cb5f8bb5-df11-4c9d-974a-62a9e272ebf1','ff6b443b-958b-4cf9-b187-d0f6da6b6d94',now()),
    ('511ac3a2-9e54-11e9-a2a3-2a2ae2dbcce4',5,'19a762fa-143b-41fe-8ec0-d22630234863','0d414ccb-55a2-480f-93ff-c2af7061f0ba',now()),
    ('511ac4d8-9e54-11e9-a2a3-2a2ae2dbcce4',5,'0cec2833-2914-4516-b6dc-2c8d58d924ec','0607712c-aced-44da-8534-72d639bd9994',now()),
    ('511ac622-9e54-11e9-a2a3-2a2ae2dbcce4',5,'8f82d1c4-43d1-4f2b-86fb-0484957927a0','4863dd00-0543-40c1-9cb0-f019c11e86bf',now()),
    ('511ac762-9e54-11e9-a2a3-2a2ae2dbcce4',5,'1cb46ca4-cf55-4512-9058-eccd042d3a60','4dd3bdc2-38ab-450e-b36f-784ed6f8427d',now()),
    ('511ac8ca-9e54-11e9-a2a3-2a2ae2dbcce4',5,'d91e7c8a-0ebe-4792-a332-a175d881fe3a','df204697-a6c6-4768-a4e8-7082940fc8eb',now()),
    ('511aca00-9e54-11e9-a2a3-2a2ae2dbcce4',5,'eda4bd55-7781-4a4d-b02a-40d7488ae586','c7b372e3-ee2d-4e1e-b525-b89372399bbe',now()),
    ('511acb40-9e54-11e9-a2a3-2a2ae2dbcce4',5,'6d8752aa-4233-4ec1-be79-6ca4bdc1e2a4','24a4ce15-b68c-4b97-bb6b-244af88c0505',now()),
    ('511acc76-9e54-11e9-a2a3-2a2ae2dbcce4',5,'412d71de-64b5-46b5-a3d8-31e15ef1a075','4f1db0d2-8269-4e55-a81a-483674196b89',now()),
    ('511acda2-9e54-11e9-a2a3-2a2ae2dbcce4',5,'c458294a-d526-43f2-9bf3-447f8f963b5a','2f693094-b5f6-4e32-9c44-f079a5931c99',now()),
    ('511acfdc-9e54-11e9-a2a3-2a2ae2dbcce4',5,'976817df-1c8f-46da-8568-f61e5093f814','4dbf4014-4f2c-4c74-ad3e-2f6df3f60c5d',now()),
    ('511c3f8e-9e54-11e9-a2a3-2a2ae2dbcce4',5,'531bed64-a661-4285-baaa-09a529a81cd0','60532776-4306-4258-bbad-7e9f9e37d350',now());


INSERT IGNORE INTO entity_mapping
    (uuid,entity_mapping_type_id,entity1_uuid,entity2_uuid,date_created)
VALUES
    ('16cb3fc8-421f-46c7-be28-83d37747b5e7',3,'0efa13f3-4351-4e9c-91fd-1d33a1833028','bc475481-050a-4938-b00a-e8dc6b9b4c01',now()),
    ('51145c7b-df2a-4a32-82eb-9eab61b76420',3,'1144b765-2e6c-47b9-bb2d-e059ad1680a8','a71de1a2-aa43-496a-a533-13f47fad0129',now()),
    ('2e9e2a44-66e0-4fbf-a900-1a8075847460',3,'ff553570-8eca-4649-9c44-e1b06921796c','b1d913d1-70d8-4d6e-8aa6-e71f8b60a004',now()),
    ('c6fbc6a6-8d21-4139-b677-5dc97f52de1d',3,'0d9bf0c2-39f5-489a-a660-927f1ac97b7b','9b5f2493-fa75-44f9-80e4-bb389121ea0d',now()),
    ('2d8b8521-60b5-42a7-8d04-b61c7ea6dcf7',3,'c6e23237-5a0d-438a-9381-ac403d30054f','74c0393a-f5dd-4f4d-98bb-cedda584349b',now()),
    ('e395e2ac-fe6a-4e84-90e0-d22ac0fa6c8b',3,'79157d5d-1e45-407d-bf15-ae8dc1674a70','f0a00d58-eeb8-4454-a41c-c8c2664313ec',now()),
    ('2bc33802-c613-4129-b17a-83dec8410442',3,'d1757c49-d3eb-4b36-bb2c-1d3faf238b20','660e38b5-2599-4ff5-b3fe-5c3fe0a5cd7e',now()),
    ('e2086e7f-91b8-429c-ade4-0afc6e357168',3,'4f2e70b3-9b18-4773-994e-c67b31422722','b7d778bb-53ab-479c-a903-5bf18a62b0f3',now()),
    ('8c84be81-5994-4404-9dc5-c68f7c54a069',3,'8568c575-16fc-4330-a3bb-c0460c15a298','9eb68046-b654-4884-b560-d1275caa84a7',now()),
    ('12047f96-8777-47ed-9539-74369c7adf4d',3,'31b46228-0cb2-4e33-b8aa-4fcbae016adc','34cefcc2-0f50-4589-a487-9a68cdf3c11a',now()),
    ('4e187cb4-deeb-4eda-a802-c8cbb359ea44',3,'ee0644c1-53e1-4c8c-bcd9-2308c608be60','dc0c872a-97d5-4731-aa00-ab8dd712e761',now()),
    ('4cd716d2-2715-4909-9d20-fb559757c64b',3,'ff6b443b-958b-4cf9-b187-d0f6da6b6d94','cb5f8bb5-df11-4c9d-974a-62a9e272ebf1',now()),
    ('3c6b1c51-aa28-4bbc-84e8-3c30cbfc60ef',3,'0d414ccb-55a2-480f-93ff-c2af7061f0ba','19a762fa-143b-41fe-8ec0-d22630234863',now()),
    ('7d96a80f-f2d1-48d9-99c1-d97b4f863d02',3,'0607712c-aced-44da-8534-72d639bd9994','0cec2833-2914-4516-b6dc-2c8d58d924ec',now()),
    ('5e440413-368f-4efa-8151-3e7714ed04c3',3,'4863dd00-0543-40c1-9cb0-f019c11e86bf','8f82d1c4-43d1-4f2b-86fb-0484957927a0',now()),
    ('2af830ee-4f53-43a7-bfd9-91b23dedf7db',3,'4dd3bdc2-38ab-450e-b36f-784ed6f8427d','1cb46ca4-cf55-4512-9058-eccd042d3a60',now()),
    ('3092bc0f-ba45-4293-8cf5-789d89b7160a',3,'df204697-a6c6-4768-a4e8-7082940fc8eb','d91e7c8a-0ebe-4792-a332-a175d881fe3a',now()),
    ('bb942fe0-f2bd-48c2-ac84-e8ce5d310316',3,'c7b372e3-ee2d-4e1e-b525-b89372399bbe','eda4bd55-7781-4a4d-b02a-40d7488ae586',now()),
    ('7ae1bd2b-d1da-4867-ac51-b7c3c2e26e8a',3,'24a4ce15-b68c-4b97-bb6b-244af88c0505','6d8752aa-4233-4ec1-be79-6ca4bdc1e2a4',now()),
    ('80267bb8-ca76-41e7-a076-4fb8bc8bf4b2',3,'4f1db0d2-8269-4e55-a81a-483674196b89','412d71de-64b5-46b5-a3d8-31e15ef1a075',now()),
    ('8a66f268-52f2-4008-83ea-8e3a03021f6f',3,'2f693094-b5f6-4e32-9c44-f079a5931c99','c458294a-d526-43f2-9bf3-447f8f963b5a',now()),
    ('0ea19eed-9003-4657-bd33-dbd81e17e274',3,'4dbf4014-4f2c-4c74-ad3e-2f6df3f60c5d','976817df-1c8f-46da-8568-f61e5093f814',now()),
    ('44b1c81a-9b4c-4714-aaee-afb3f2c79cb5',3,'c5854fd7-3f12-11e4-adec-0800271c1b75','bc475481-050a-4938-b00a-e8dc6b9b4c01',now()),
    ('f1e4af1d-5150-4978-9934-26ac3a8c0c87',3,'60532776-4306-4258-bbad-7e9f9e37d350','531bed64-a661-4285-baaa-09a529a81cd0',now());