import os
import numpy as np

# ==========================================================================================================================================================
# initiate the functions and classes
# ==========================================================================================================================================================
# =============================================================================#
# functions
# =============================================================================#
def s2f(string):
    #this function is used to convert string to float in case of special type
    character_list=list(string)
    before_dot=string.split('.')[0]
    if '-' in character_list[1:]:
        after_dot=string.split('.')[1].split('-')[0]
        exponent=string.split('.')[1].split('-')[1]
        float_num=float(before_dot+'.'+after_dot)/(10**(int(exponent)))
    elif '+' in character_list[1:]:
        after_dot=string.split('.')[1].split('+')[0]
        exponent=string.split('.')[1].split('+')[1]
        float_num=float(before_dot+'.'+after_dot)*10**(int(exponent))
    else:
        float_num=float(string)

    return float_num

def normalize_vetor(x21,y21,z21):
    #this function is used to normalize the components of a vetor back to 1
    square_sum=np.sqrt(x21**2 + y21**2 + z21**2)
    x=x21/square_sum
    y=y21/square_sum
    z=z21/square_sum
    return_list=[x,y,z]
    return return_list
    
def distance(x1,y1,z1,x2,y2,z2):
    #calculate the distance between two points provided by their coordinates
    x=x2-x1; y=y2-y1; z=z2-z1
    distance=np.sqrt(x**2 + y**2 + z**2)
    return distance

# =============================================================================#
# fem class data
# =============================================================================#
pten_list=[]; npten_list=[]; pten_dict={'name': 'pretesion dictionary'}
class pretension: 
    def __init__(self,elemid):
        self.rodid=elemid

syst_list=[]; nsyst_list=[]; syst_dict={'name': 'system dictionary'}
class system:
    def __init__(self,A1,A2,A3,B1,B2,B3,C1,C2,C3):
        self.a1=A1; self.a2=A2; self.a3=A3
        self.b1=B1; self.b2=B2; self.b3=B3
        self.c1=C1; self.c2=C2; self.c3=C3

node_list=[]; nnode_list=[]; node_dict={'name': 'node dictionary'}
class node:
    def __init__(self, xcoord, ycoord, zcoord, system):
        self.x=xcoord; self.y=ycoord; self.z=zcoord; self.syst=system

crod_list=[]; ncrod_list=[]; crod_dict={'name': 'crod dictionary'}
class crod:
    def __init__(self,propid,node1,node2):
        self.prop=propid; self.n1=node1; self.n2=node2;
        
cbush_list=[]; ncbush_list=[]; cbush_dict={'name': 'cbush dictionary'};
class cbush:
    def __init__(self,propid,node1,node2,system):
        self.prop=propid; self.n1=node1; self.n2=node2; self.syst=system;

rbe2_list=[]; nrbe2_list=[]; rbe2_dict={'name': 'rbe2 dictionary'}
class rbe2:
    def __init__(self,node1,node2):
        self.n1=node1; self.n2=node2;

rbe3_list=[]; nrbe3_list=[]; rbe3_dict={'name': 'rbe3 dictionary'}
class rbe3:
    def __init__(self,nodeid,nodelist):
        self.dpd=nodeid
        self.idplist=nodelist

quad_list=[]; nquad_list=[]; quad_dict={'name': 'quad dictionary'}
class quad4:
    def __init__(self,propid,node1,node2,node3,node4):
        self.n1=node1; self.n2=node2; self.n3=node3; self.n4=node4; self.prop=propid

pshell_list=[]; npshell_list=[]; pshell_dict={'name': 'pshell dictionary'}
class pshell:
    def __init__(self,materialid,thickness):
        self.matid=materialid
        self.T=thickness
pbush_list=[]; npbush_list=[]; pbush_dict={'name': 'pbush dictionary'}       
class pbush:
    def __init__(self,k1,k2,k3):
        self.K1=k1; self.K2=k2; self.K3=k3;

prod_list=[]; nprod_list=[]; prod_dict={'name': 'prod dictionary'}
class prod:
    def __init__(self,materialid,area,jmoment):
        self.matid=materialid; self.a=area; self.j=jmoment;

mat1_list=[]; nmat1_list=[]; mat1_dict={'name': 'mat1 dictionary'}
class mat1:
    def __init__(self, young_modul, poisson):
        self.E=young_modul; self.Nu=poisson;

ptf_list=[]; nptf_list=[]; ptf_dict={'name': 'ptforce dictionary'}
class ptforce:
    def __init__(self,sectionid,force):
        self.sid=sectionid; self.f=force;

prod_proj={'name': 'dictionary to project to crodid by prod id'}
pbush_proj={'name': 'dictionary to project to cbush id list by pbush id'}

# =============================================================================#
# pch class data
# =============================================================================#
ptdisp_dict={'name': 'displacement result of pretension loadstep dictionary'}
lsdisp_dict={'name': 'displacement result of linear static loadstep dictionary'}
class disp:
    def __init__(self, x_result, y_result, z_result):
        self.x=x_result; self.y=y_result; self.z=z_result

cquad_stress_dict={'name': 'CQUAD elements stress output'}
crod_stress_dict={'name': 'CROD element stress ouput'}  

# =============================================================================#
# post processing class data
# =============================================================================#
force_dict={'name': 'joint force dictionary'}   
class bolt_force:
    def __init__(self, simplified_Fbolt, detail_Fbolt, sheary, shearz , bendy, bendz):
        self.simfb=simplified_Fbolt
        self.detfb=detail_Fbolt
        self.fshey=sheary
        self.fshez=shearz
        self.fshep=np.sqrt(sheary**2+shearz**2)
        self.bendy=bendy
        self.bendz=bendz
        self.bendp=np.sqrt(bendy**2+bendz**2)

stress_dict={'name': 'stress result dictionary'}; stre_list=[]
class bolt_stress:
    def __init__(self, axial_stress, shear_stress, vonmise_stress):
        self.axial=axial_stress; self.shear=shear_stress; self.vons=vonmise_stress

# ==========================================================================================================================================================
# read and processing the fem file
# ==========================================================================================================================================================
# =============================================================================#
# Import FEM data
# =============================================================================#
curdir=os.path.dirname(__file__)
file_path=curdir+"/data/opt_file.fem"
file = open(file_path,'r')
linedata=file.readlines()
file.close()

i=0;
for line in linedata:
    charlist=line.split(' ')
    if charlist[0]=='PRETENS*':
        pten_dict[int(line[8:24])]=pretension(int(line[24:40]));
        pten_list.append(int(line[8:24])); npten_list.append(int(line[8:24]))
    
    if charlist[0]=='CORD2R*':
        line2=linedata[i+1]; line3=linedata[i+2]
        A1=s2f(line[40:56]); A2=s2f(line[56:72]); A3=s2f(line2[8:24])
        B1=s2f(line2[24:40]); B2=s2f(line2[40:56]); B3=s2f(line2[56:72])
        C1=s2f(line3[8:24]); C2=s2f(line3[24:40]); C3=s2f(line3[40:56]) 
        syst_dict[int(line[8:24])]=system(A1,A2,A3,B1,B2,B3,C1,C2,C3)
        syst_list.append(int(line[8:24])); nsyst_list.append(int(line[8:24])); 
        
    if charlist[0]=='GRID*':
        nextline=linedata[i+1];
        x=s2f(line[40:56]); 
        y=s2f(line[56:72]); 
        z=s2f(nextline[8:24]);
        if len(nextline)<30:
            syst=0
        else:
            syst=int(nextline[24:40]) 
        node_dict[int(line[8:24])]=node(x,y,z,syst)
        node_list.append(int(line[8:24])); nnode_list.append(int(line[8:24]))
    
    if charlist[0]=='CROD*':
        crod_dict[int(line[8:24])]=crod(int(line[24:40]),int(line[40:56]),int(line[56:72]));
        crod_list.append(int(line[8:24])); ncrod_list.append(int(line[8:24]))
    
    if charlist[0]=='CBUSH*':
        nextline=linedata[i+1];
        cbush_dict[int(line[8:24])]=cbush(int(line[24:40]), int(line[40:56]), int(line[56:72]), int(nextline[56:72]));
        cbush_list.append(int(line[8:24])); ncbush_list.append(int(line[8:24]))
        
    if charlist[0]=='RBE2*':
        rbe2_dict[int(line[8:24])]=rbe2(int(line[24:40]), int(line[56:72]))
        rbe2_list.append(int(line[8:24])); nrbe2_list.append(int(line[8:24]))
    
    if charlist[0]=='RBE3*':
        idplist=[]; idplist.extend(linedata[i+1].split()[3:5])
        k=i+2; charlist2=linedata[k].split()
        while charlist2[0]=='*':
            idplist.extend(charlist2[1:])
            k=k+1; charlist2=linedata[k].split()
        rbe3_dict[int(line[8:24])]=rbe3(int(line[40:56]),list(map(int,idplist)))
        rbe3_list.append(int(line[8:24])); nrbe3_list.append(int(line[8:24]))
    
    if charlist[0]=='CQUAD4*':
        nextline=linedata[i+1];
        quad_dict[int(line[8:24])]=quad4(int(line[24:40]), int(line[40:56]), int(line[56:72]), int(nextline[8:24]), int(nextline[24:40]))
        quad_list.append(int(line[8:24])); nquad_list.append(int(line[8:24]))
    
    if charlist[0]=='PSHELL*':
        pshell_dict[int(line[8:24])]=pshell(int(line[24:40]), float(line[40:56]))
        pshell_list.append(int(line[8:24])); npshell_list.append(int(line[8:24]))
    
    if charlist[0]=='PBUSH*':
        nextline=linedata[i+1];
        pbush_dict[int(line[8:24])]=pbush(float(line[40:56]), float(line[56:72]), float(nextline[8:24]))
        pbush_list.append(int(line[8:24])); npbush_list.append(int(line[8:24]))
    
    if charlist[0]=='PROD*':
        prod_dict[int(line[8:24])]=prod(int(line[24:40]), float(line[40:56]), float(line[56:72]))
        prod_list.append(int(line[8:24])); nprod_list.append(int(line[8:24]))
    
    if charlist[0]=='MAT1*':
        nextline=linedata[i+1]
        mat1_dict[int(line[8:24])]=mat1(float(line[24:40]), float(line[56:72]))
        mat1_list.append(int(line[8:24])); nmat1_list.append(int(line[8:24]))
    
    if charlist[0]=='PTFORCE*':
        ptf_dict[int(line[24:40])]=ptforce(int(line[24:40]), float(line[40:56]))
        ptf_list.append(int(line[8:24])); nptf_list.append(int(line[8:24]))
        
        
    i=i+1

# =============================================================================#
# Redistribute the CROD, CBUSH elements according to the PROD, PBUSH id
# =============================================================================#
for crodid in crod_list:
    prod_proj[crod_dict[crodid].prop]=crodid
for pbushid in pbush_list:
    pbush_proj[pbushid]=[]
for cbushid in cbush_list:
    pbush_proj[cbush_dict[cbushid].prop].append(cbushid)

# ==========================================================================================================================================================
# read and processing the pch file
# ==========================================================================================================================================================
curdir=os.path.dirname(__file__)
file_path=curdir+"/data/opt_file.pch"
file = open(file_path,'r')
linedata=file.readlines()
file.close()

mode='none'; stre_list=[]; i=0

for line in linedata:
    charlist=line.split()
    if charlist[0]=='$TITLE':
        mode='none'
    
    if line=='$LABEL   = pretension\n':
        if linedata[i+1]=='$DISPLACEMENTS\n':
            mode='ptdisp'
        
    if line=='$LABEL   = ls\n':
        if linedata[i+1]=='$DISPLACEMENTS\n':
            mode='lsdisp'
        elif linedata[i+4]=='$ELEMENT TYPE =          33   (CQUAD4)\n':
            mode='cquad'
        elif linedata[i+4]=='$ELEMENT TYPE =           1   (CROD)\n':
            mode='crod'
            
    if charlist[0].isdigit():
        if mode=='ptdisp':
            ptdisp_dict[int(charlist[0])]=disp(float(charlist[2]), float(charlist[3]), float(charlist[4]))
        if mode=='lsdisp':
            lsdisp_dict[int(charlist[0])]=disp(float(charlist[2]), float(charlist[3]), float(charlist[4]))
        elif mode=='cquad':
            #read the principle stress on the cquad elemement
            stre_list.append(max(float(linedata[i+1].split()[3]),float(linedata[i+4].split()[2])))
            cquad_stress_dict[int(charlist[0])]=max(stre_list)
        elif mode=='crod':
            crod_stress_dict[int(charlist[0])]=float(charlist[1])
    
    i=i+1
    
# ==========================================================================================================================================================
# post processing the result
# ==========================================================================================================================================================
for prodid in nprod_list:
    #=========================================================================
    #calculate the system origin and vector
    #=========================================================================
    A1=syst_dict[prodid].a1; A2=syst_dict[prodid].a2; A3=syst_dict[prodid].a3
    B1=syst_dict[prodid].b1; B2=syst_dict[prodid].b2; B3=syst_dict[prodid].b3
    BA1=B1-A1; BA2=B2-A2; BA3=B3-A3; CA1=C1-A1; CA2=C2-A2; CA3=C3-A3;
    D1=BA3*CA2-BA2*CA3; D2=BA3*CA1-BA1*CA3; D3=BA1*CA2-CA1*BA2
    orgin=[A1,A2,A3]; z_vect=normalize_vetor(BA1,BA2,BA3); y_vect=normalize_vetor(D1,D2,D3)
    x_vect=[y_vect[1]*z_vect[2]-y_vect[2]*z_vect[1],
            y_vect[2]*z_vect[0]-y_vect[0]*z_vect[2],
            y_vect[0]*z_vect[1]-y_vect[1]*z_vect[0]]
    AxOy=z_vect[0]; BxOy=z_vect[1]; CxOy=z_vect[2]; DxOy=-(AxOy*A1+BxOy*A2+CxOy*A3);    #xOy Plane
    AxOz=y_vect[0]; BxOz=y_vect[1]; CxOz=y_vect[2]; DxOz=-(AxOz*A1+BxOz*A2+CxOz*A3);    #xOz plane
    
    #=========================================================================
    #calculate the bolt axial force from the CROD elements
    #=========================================================================
    crod_id=prod_proj[prodid]; N1=crod_dict[crod_id].n1; N2=crod_dict[crod_id].n2;                    
    L=distance(node_dict[N1].x,node_dict[N1].y,node_dict[N1].z,node_dict[N2].x,node_dict[N2].y,node_dict[N2].z)
    FXROD=crod_stress_dict[crod_id]*prod_dict[prodid].a
    
    #=========================================================================
    #calculate the bolt forces from CBUSH elements
    #=========================================================================
    ptforce=ptf_dict[prodid].f; pbushid_axial=prodid*10; pbushid_shear=prodid*10+1
    Kx=pbush_dict[pbushid_axial].K1; Ky=pbush_dict[pbushid_shear].K2; Kz=pbush_dict[pbushid_shear].K3;
    
    FXBUSH,MYBUSH,MZBUSH=0,0,0;   #axial force, bending moments
    for cbushid in pbush_proj[pbushid_axial]: 
        N1=cbush_dict[cbushid].n1; N2=cbush_dict[cbushid].n2; x=node_dict[N1].x; y=node_dict[N1].y; z=node_dict[N1].z;
        ptdx1=ptdisp_dict[N1].x; ptdx2=ptdisp_dict[N2].x; ptDx=ptdx2-ptdx1     #displacement result of pretension analysis
        lsdx1=lsdisp_dict[N1].x; lsdx2=lsdisp_dict[N2].x; lsDx=lsdx2-lsdx1     #displacement result of linear static analysis
        FX=(lsDx-ptDx)*Kx; FXBUSH=FXBUSH+FX                                    #axial force
        dxOy=(AxOy*x+BxOy*y+CxOy*z+DxOy)/(np.sqrt(AxOy**2+BxOy**2+CxOy**2))    #calculate the distance from the cbush to xOy plane
        MYBUSH=MYBUSH+FX*dxOy                                                  #moment around Y axis
        dxOz=(AxOz*x+BxOz*y+CxOz*z+DxOz)/(np.sqrt(AxOz**2+BxOz**2+CxOz**2))    #calculate the distance from the cbush to xOz plane
        MZBUSH=MZBUSH+FX*dxOz                                                  #moment around Z axis
    
    FYBUSH,FZBUSH=0,0;   #shear force
    for cbushid in pbush_proj[pbushid_shear]:
        N1=cbush_dict[cbushid].n1; N2=cbush_dict[cbushid].n2
        dy1=lsdisp_dict[N1].y; dz1=lsdisp_dict[N1].z
        dy2=lsdisp_dict[N2].y; dz2=lsdisp_dict[N2].z
        Dy=dy2-dy1; Dz=dz2-dz1
        FY=Dy*Ky; FYBUSH=FYBUSH+FY                           
        FZ=Dz*Kz; FZBUSH=FZBUSH+FZ    
    
    #=========================================================================
    #calculate the bolt forces from CBUSH elements
    #=========================================================================
    F_tensile_total=FXROD+FXBUSH;                 #total tensile force on bolt joint
    F_external=F_tensile_total-ptforce            #external load on bolt joint
    
    #calculate the bolt force base on the simplified model
    k_bolt=prod_dict[prodid].a*mat1_dict[prod_dict[prodid].matid].E/L
    k_grip=Kx*len(pbush_proj[pbushid_axial])
    F_bolt_simple=F_external*k_bolt/(k_bolt+k_grip)
    
    #calculate the bolt force base on the detail model and prying force prediction
    r=8
    Abolt = np.pi*r**2
    new_k_bolt=1/(1/k_bolt + 12.5/(Abolt*mat1_dict[prod_dict[prodid].matid].E))
    edge=50;  
    Q=np.sqrt(MYBUSH**2+MZBUSH**2)/(1*edge)
    F_bolt = F_external*new_k_bolt/(new_k_bolt+k_grip)
    F_bolt_detail=F_external*new_k_bolt/(new_k_bolt+k_grip)+Q
    
    #the force directionary to store the force on each bolted joint
    force_dict[prodid]=bolt_force(F_bolt, F_bolt_detail, FYBUSH, FZBUSH, MYBUSH, MZBUSH)
    