import xml.etree.cElementTree as ET
from collections import defaultdict
import re
import pprint

OSMFILE = "delaware_beach.osm"
street_type_re = re.compile(r'\b\S+\.?$', re.IGNORECASE)


expected = ["Boardwalk", "Street", "Avenue", "Boulevard", "Drive", "Court", "Place", "Square", "Lane", "Road",
            "Trail", "Parkway", "Commons","Crescent","Close","East","West","North","South","Way","Terrace"]

# UPDATE THIS VARIABLE
mapping = { "St": "Street",
            "St.": "Street",
            "Blvd": "Boulevard",
            "Blvd.": "Boulevard",
            "Ave": "Avenue",
            "Ave.": "Avenue",
            "Rd": "Road",
            "STREET": "Street",
            "avenue": "Avenue",
            "street": "Street",
            "E": "East",
            "W": "West",
            "Ln": "Lane",
            "Cout": "Court",
            "Hwy": "Highway",
            "N": "North",
            "S": "South",
            "Bdwk": "Boardwalk"
            }


def audit_street_type(street_types, street_name):
    m = street_type_re.search(street_name)
    if m:
        street_type = m.group()
        if street_type not in expected:
            street_types[street_type].add(street_name)


def is_street_name(elem):
    return (elem.attrib['k'] == "addr:street")


def audit(osmfile):
    osm_file = open(osmfile, "r")
    street_types = defaultdict(set)
    for event, elem in ET.iterparse(osm_file, events=("start",)):

        if elem.tag == "node" or elem.tag == "way":
            for tag in elem.iter("tag"):
                if is_street_name(tag):
                    audit_street_type(street_types, tag.attrib['v'])
                    print (street_types)
                    break
    osm_file.close()
    return street_types


def update_name(name, mapping):

    for key, value in mapping.iteritems():
        if re.search(key, name):
            name = re.sub(street_type_re, value, name)

    return name


def do_things():
    st_types = audit(OSMFILE)
    pprint.pprint(dict(st_types))

    return

if __name__ == '__main__':
    do_things()