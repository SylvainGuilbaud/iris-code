import iknowpy
import sys
from colorama import init, Fore, Back, Style

# Available formatting constants are:
# FORE: BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, RESET.
# BACK: BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, RESET.
# STYLE: DIM, NORMAL, BRIGHT, RESET_ALL

init() # init colorama

def highlight(text, language="en", iknow=iknowpy.iKnowEngine()):

    # show supported languages
    # print(iknow.get_languages_set())

    iknow.index(text, language)

    # print the raw results
    print(iknow.m_index)

    # or make it a little nicer
    # for s in iknow.m_index['sentences']:
    #     for e in s['entities']:
    #         print('\n'+e['type']+" : "+e['index'], end=' ') 
    #     for e in s['sent_attributes']:
    #             print('\n'+e['type']+" : "+e['marker'], end=' ')         
    #     print('\n')

    for s in iknow.m_index['sentences']:
            
        # first figure out where negation spans are and tag those entities
        for pa in s['path_attributes']:
            
            # path attributes are expressed as positions within s['path'],
            # which in turn keys into the s['entities'] array
            for ent in range(s['path'][pa['pos']], 
                             s['path'][pa['pos']+pa['span']-1]+1):
                if pa['type']=="Negation":
                    s['entities'][ent]['colour'] = Fore.RED
                if pa['type']=="Certainty":
                    s['entities'][ent]['colour'] = Fore.CYAN
        
      
            # if sa['type']=="DateTime":
                  
                # for e in s['entities']:
                #     if sa['entity_ref'] == e('entity_id'):
                #         e['entities'][e]['colour'] = Back.WHITE
            
            # print('\n'+sa['type']+" : "+sa['marker'], end='\n') 
                
                # s['entities']['marker']['colour'] = Back.WHITE
        

        for e in s['entities']:
            colour = Fore.GREEN
            style = Style.NORMAL

            if "colour" in e:
                colour = e["colour"]
                
            if (e['type'] == 'Concept'):
                style = Style.BRIGHT
            if (e['type'] == 'NonRelevant') | (e['type'] == 'PathRelevant'):
                style = Style.DIM
            
            for sa in s['sent_attributes']:
                if e['offset_start'] == sa['offset_start']: 
                    colour = Fore.BLUE
                    style = Style.NORMAL
            
            print(colour + style + text[e['offset_start']:e['offset_stop']], end='\n')
            print(Style.RESET_ALL)

highlight(sys.argv[1],sys.argv[2])