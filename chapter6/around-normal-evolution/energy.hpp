namespace Energy
{
    template<class TIterator>
    void Term::add(double uOut,double uInn,TIterator begin, TIterator end)
    {
        const VariableMap::PixelIndexMap &iiv = vm.pim;
        for(auto itj=begin;itj!=end;++itj)
        {
            unsigned int xj = iiv.at(itj->first);
            UTM(1,xj) += (1-2*uOut) - (1-2*uInn);


//            auto itk=itj;
//            ++itk;
//            for(;itk!=end;++itk)
//            {
//                auto ip = std::make_pair(xj,iiv.at(itk->first));
//
//                if(ET.find(ip)==ET.end()) ET[ip] = BooleanConfigurations(0,0,0,0);
//                ET[ip].e11 -= 2;
//            }
        }

    }
}