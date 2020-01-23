namespace Energy
{
    template<class TIterator>
    void Term::add(double fOut,double fInn,double A,double S,TIterator begin, TIterator end)
    {
        const VariableMap::PixelIndexMap &iiv = vm.pim;
        for(auto itj=begin;itj!=end;++itj)
        {
            unsigned int xj = iiv.at(itj->first);
            double wj = itj->second;

            UTM(1,xj) += wj*(fOut-fInn+1);

            auto itk=itj;
            ++itk;
            for(;itk!=end;++itk)
            {
                IndexPair ip = makePair(xj,iiv.at(itk->first));
                double wk = itk->second;

                if(ET.find(ip)==ET.end()) ET[ip] = BooleanConfigurations(0,0,0,0);
                ET[ip].e11 += 2*wk*wj;
            }

//            double cOut=4*fOut*(fOut-fInn);
//            double cInn=4*fInn*(fOut-fInn);
//            UTM(1,xj) += cOut*(1+fOut-2*A) - cInn*(1+fInn-2*A);
//
//            auto itk=itj;
//            ++itk;
//            for(;itk!=end;++itk)
//            {
//                IndexPair ip = makePair(xj,iiv.at(itk->first));
//
//                if(ET.find(ip)==ET.end()) ET[ip] = BooleanConfigurations(0,0,0,0);
//                ET[ip].e11 += 2*(cOut-cInn);
//            }
        }

    }
}