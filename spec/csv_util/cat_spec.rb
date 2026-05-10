# frozen_string_literal: true

require 'spec_helper'

def csv_file string
  tmpfile = Tempfile.new
  tmpfile.write string
  tmpfile.rewind
  tmpfile.path
end

RSpec.describe CSVUtil::Cat do
  let(:subject) { CSVUtil::Cat.new csv1_file, csv2_file }

  let(:csv1_file) { csv_file csv1 }
  let(:csv2_file) { csv_file csv2 }

  let(:csv1) {
    <<~EOF
      first_col,second_col,third_col
      easel,floor,girder
      egg,fig,grape
      elbow,foot,gut
      eager,fickle,giddy
      steak,fig,cheese
      cucumber,fig,omelet
    EOF
  }

  let(:csv2) {
    <<~EOF
      first_col,second_col,third_col
      lemon,mango,nectarine
      orange,pineapple,quince
      strawberry,tomato,uglifruit
      vanilla,watermelon,xylophone
    EOF
  }

  let(:expected) {
    <<~EOF
      first_col,second_col,third_col
      easel,floor,girder
      egg,fig,grape
      elbow,foot,gut
      eager,fickle,giddy
      steak,fig,cheese
      cucumber,fig,omelet
      lemon,mango,nectarine
      orange,pineapple,quince
      strawberry,tomato,uglifruit
      vanilla,watermelon,xylophone
    EOF
  }

  context 'implementations' do
    it_behaves_like 'a command implementation'
  end

  context '#process' do
    context 'with 2 CSVs' do
      it 'concatenates the CSVs' do
        expect { subject.process }.to output(expected).to_stdout
      end
    end

    context 'with 3 CSVs' do
      let(:subject) { CSVUtil::Cat.new csv1_file, csv2_file, csv3_file }

      let(:csv3) {
        <<~EOF
          first_col,second_col,third_col
          zebra,wombat,viper
          unicorn,tapir,springbok
          rhino,quokka,platypus
        EOF
      }

      let(:csv3_file) { csv_file csv3 }

      let(:expected) {
        <<~EOF
          first_col,second_col,third_col
          easel,floor,girder
          egg,fig,grape
          elbow,foot,gut
          eager,fickle,giddy
          steak,fig,cheese
          cucumber,fig,omelet
          lemon,mango,nectarine
          orange,pineapple,quince
          strawberry,tomato,uglifruit
          vanilla,watermelon,xylophone
          zebra,wombat,viper
          unicorn,tapir,springbok
          rhino,quokka,platypus
        EOF
      }

      it 'has the expected output' do
        expect { subject.process }.to output(expected).to_stdout
      end
    end

    context 'with overlapping headers' do
      let(:csv2) {
        <<~EOF
          second_col,third_col,fourth_col
          lemon,mango,nectarine
          orange,pineapple,quince
          strawberry,tomato,uglifruit
          vanilla,watermelon,xylophone
        EOF
      }

      let(:expected) {
        <<~EOF
          first_col,second_col,third_col,fourth_col
          easel,floor,girder,
          egg,fig,grape,
          elbow,foot,gut,
          eager,fickle,giddy,
          steak,fig,cheese,
          cucumber,fig,omelet,
          ,lemon,mango,nectarine
          ,orange,pineapple,quince
          ,strawberry,tomato,uglifruit
          ,vanilla,watermelon,xylophone
        EOF
      }

      it 'has the expected output' do
        expect { subject.process }.to output(expected).to_stdout
      end
    end

    context 'with different header' do
      let(:csv2) {
        <<~EOF
          a_col,b_col,c_col
          lemon,mango,nectarine
          orange,pineapple,quince
          strawberry,tomato,uglifruit
          vanilla,watermelon,xylophone
        EOF
      }

      let(:expected) {
        <<~EOF
          first_col,second_col,third_col,a_col,b_col,c_col
          easel,floor,girder,,,
          egg,fig,grape,,,
          elbow,foot,gut,,,
          eager,fickle,giddy,,,
          steak,fig,cheese,,,
          cucumber,fig,omelet,,,
          ,,,lemon,mango,nectarine
          ,,,orange,pineapple,quince
          ,,,strawberry,tomato,uglifruit
          ,,,vanilla,watermelon,xylophone
        EOF
      }

      it 'has the expected output' do
        expect { subject.process }.to output(expected).to_stdout
      end
    end
  end

end
